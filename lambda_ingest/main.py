import os
import json
import logging
import boto3
import psycopg2
import fitz
import tiktoken
import urllib.parse

logger = logging.getLogger()
logger.setLevel(logging.INFO)

REGION = os.environ.get("AWS_REGION", "us-east-1")
SECRET_NAME = os.environ["DB_SECRET_NAME"]
MODEL_ID = "amazon.titan-embed-text-v2:0"
EXPECTED_VECTOR_DIM = 1024

def get_db_credentials():
    logger.info("Fetching database credentials from Secrets Manager")
    client = boto3.client('secretsmanager', region_name=REGION)
    secret = client.get_secret_value(SecretId=SECRET_NAME)
    return json.loads(secret['SecretString']) 

def connect_db():
    creds = get_db_credentials()
    logger.info("Connecting to PostgreSQL database")
    return psycopg2.connect(
        host=creds['host'],
        database=creds['dbname'],
        user=creds['username'],
        password=creds['password'],
        port=creds['port']
    )

def get_titan_embedding(text):
    logger.info("Calling Amazon Titan embedding model for ingestion")
    client = boto3.client("bedrock-runtime", region_name=REGION)
    payload = {
        "inputText": text
    }
    response = client.invoke_model(
        modelId=MODEL_ID,
        contentType="application/json",
        accept="application/json",
        body=json.dumps(payload)
    )
    body = json.loads(response['body'].read())
    return body["embedding"]

def chunk_text(text, max_tokens=500):
    logger.info("Starting tokenization and chunking")
    tokenizer = tiktoken.get_encoding("cl100k_base")
    tokens = tokenizer.encode(text)
    chunks = [tokens[i:i+max_tokens] for i in range(0, len(tokens), max_tokens)]
    logger.info(f"Chunked into {len(chunks)} pieces")
    return [tokenizer.decode(chunk) for chunk in chunks]

def lambda_handler(event, context):
    try:
        # Extract S3 bucket and key
        record = event['Records'][0]
        bucket = record['s3']['bucket']['name']
        raw_key = record['s3']['object']['key']
        file_key = urllib.parse.unquote_plus(raw_key)

        logger.info(f"Triggered by: s3://{bucket}/{file_key}")
        s3 = boto3.client('s3')
        obj = s3.get_object(Bucket=bucket, Key=file_key)
        file_bytes = obj['Body'].read()
        file_size_kb = len(file_bytes) / 1024
        logger.info(f"File fetched: {file_key} ({file_size_kb:.2f} KB)")

        ext = os.path.splitext(file_key)[-1].lower()

        if ext == ".pdf":
            logger.info("Extracting text from PDF")
            with fitz.open(stream=file_bytes, filetype="pdf") as doc:
                text = "\n".join(page.get_text() for page in doc)
        elif ext == ".txt":
            logger.info("Reading plain text file")
            text = file_bytes.decode("utf-8")
        else:
            logger.warning(f"Unsupported file type: {ext}")
            return {"error": f"Unsupported file type: {ext}", "file": file_key}

        if not text.strip():
            logger.warning("No text extracted")
            return {"warning": "No text extracted from file", "file": file_key}

        chunks = chunk_text(text)

        conn = connect_db()
        cur = conn.cursor()

        logger.info("Ensuring documents table exists with correct vector dimension (1024)")
        cur.execute("""
            CREATE TABLE IF NOT EXISTS documents (
                id SERIAL PRIMARY KEY,
                chunk TEXT,
                embedding VECTOR(1024)
            );
        """)

        logger.info("Inserting chunks and generating embeddings into database")
        for i, chunk in enumerate(chunks):
            try:
                embedding = get_titan_embedding(chunk)
                if len(embedding) != EXPECTED_VECTOR_DIM:
                    logger.warning(f"Chunk {i+1} embedding dimension mismatch: {len(embedding)} != {EXPECTED_VECTOR_DIM}")
                    continue

                cur.execute(
                    "INSERT INTO documents (chunk, embedding) VALUES (%s, %s)", (chunk, embedding)
                )
                logger.info(f"Inserted chunk {i+1}/{len(chunks)} successfully")
            except Exception as e:
                logger.error(f"Failed to insert chunk {i+1}: {e}")
                conn.rollback()  # Prevent transaction abortion on error
                continue

        conn.commit()
        cur.close()
        conn.close()

        logger.info(f"Successfully stored {len(chunks)} chunks for file {file_key}")
        return {
            "status": "success",
            "chunks_stored": len(chunks),
            "file": file_key,
            "file_size_kb": round(file_size_kb, 2)
        }

    except Exception as e:
        logger.exception("Unhandled exception occurred")
        return {"error": str(e), "file": file_key if 'file_key' in locals() else None}