import os
import json
import logging
import boto3
import psycopg2

logger = logging.getLogger()
logger.setLevel(logging.INFO)

REGION = os.environ.get("AWS_REGION", "us-east-1")
SECRET_NAME = os.environ["DB_SECRET_NAME"]
MODEL_ID = "amazon.titan-embed-text-v2:0"
EXPECTED_VECTOR_DIM = 1024

def get_db_credentials():
    client = boto3.client('secretsmanager', region_name=REGION)
    secret = client.get_secret_value(SecretId=SECRET_NAME)
    return json.loads(secret['SecretString'])

def connect_db():
    creds = get_db_credentials()
    logger.info("Connecting to PostgreSQL DB")
    return psycopg2.connect(
        host=creds['host'],
        database=creds['dbname'],
        user=creds['username'],
        password=creds['password'],
        port=creds['port']
    )

def get_titan_embedding(text):
    logger.info("Calling Amazon Titan embedding model")
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

def lambda_handler(event, context):
    try:
        logger.info("Parsing input event")
        body = json.loads(event.get("body", "{}"))
        query = body.get("query")

        if not query or not isinstance(query, str) or not query.strip():
            return {
                "statusCode": 400,
                "body": json.dumps({"error": "Missing or invalid 'query'"})
            }

        embedding = get_titan_embedding(query)
        if len(embedding) != EXPECTED_VECTOR_DIM:
            logger.warning(f"Unexpected embedding size: {len(embedding)} != {EXPECTED_VECTOR_DIM}")
            return {
                "statusCode": 500,
                "body": json.dumps({"error": "Invalid embedding vector dimension"})
            }

        # Convert list of floats to Postgres-compatible vector string
        embedding_str = f"[{', '.join(map(str, embedding))}]"

        conn = connect_db()
        cur = conn.cursor()

        logger.info("Executing pgvector semantic search query")
        cur.execute("""
            SELECT chunk, embedding <#> %s::vector AS score
            FROM documents
            WHERE embedding IS NOT NULL
            ORDER BY score ASC
            LIMIT 5;
        """, (embedding_str,))

        raw_results = cur.fetchall()
        results = [
            {
                "rank": idx + 1,
                "chunk": row[0].strip(),
                "score": round(row[1], 4),
                "confidence": round(1 - row[1] / 2, 3)
            }
            for idx, row in enumerate(raw_results)
        ]

        cur.close()
        conn.close()

        logger.info(f"Search successful. Returning {len(results)} results.")
        return {
            "statusCode": 200,
            "body": json.dumps({
                "query": query,
                "results": results,
                "count": len(results)
            })
        }

    except Exception as e:
        logger.exception("Unhandled error in Lambda")
        return {
            "statusCode": 500,
            "body": json.dumps({"error": str(e)})
        }