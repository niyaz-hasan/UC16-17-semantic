import boto3
import os
import psycopg2
import fitz  # PyMuPDF
import tiktoken
import logging
import urllib.parse

logger = logging.getLogger()
logger.setLevel(logging.INFO)

SECRET_NAME = os.environ['DB_SECRET_NAME']
REGION = os.environ.get('AWS_REGION', 'us-east-1')

def get_db_credentials():
    logger.info("Fetching database credentials from Secrets Manager")
    client = boto3.client('secretsmanager', region_name=REGION)
    secret = client.get_secret_value(SecretId=SECRET_NAME)
    return eval(secret['SecretString'])

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
            doc = fitz.open(stream=file_bytes, filetype="pdf")
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

        logger.info("Ensuring documents table exists")
        cur.execute("""
            CREATE TABLE IF NOT EXISTS documents (
                id SERIAL PRIMARY KEY,
                chunk TEXT,
                embedding VECTOR(384)
            );
        """)

        logger.info("Inserting chunks into database")
        for chunk in chunks:
            cur.execute("INSERT INTO documents (chunk, embedding) VALUES (%s, NULL)", (chunk,))

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