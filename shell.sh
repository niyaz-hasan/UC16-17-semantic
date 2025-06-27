# sudo dnf install -y postgresql15
#!/bin/bash

# === Configuration ===
SECRET_NAME="semanticdb-credentials"  # Replace with your secret name
REGION="us-east-1"                   # Replace with your region

# === Check dependencies ===
if ! command -v aws &> /dev/null; then
  echo "AWS CLI not found. Please install and configure it."
  exit 1
fi

if ! command -v jq &> /dev/null; then
  echo "jq not found. Please install jq (JSON processor)."
  exit 1
fi

if ! command -v psql &> /dev/null; then
  echo "psql not found. Please install the PostgreSQL client."
  exit 1
fi

# === Retrieve secret from AWS Secrets Manager ===
echo "Fetching PostgreSQL credentials from AWS Secrets Manager..."
SECRET_JSON=$(aws secretsmanager get-secret-value \
  --secret-id "$SECRET_NAME" \
  --region "$REGION" \
  --query SecretString \
  --output text)

if [ $? -ne 0 ]; then
  echo "Failed to fetch secret from AWS."
  exit 1
fi

# === Parse credentials ===
export PGUSER=$(echo "$SECRET_JSON" | jq -r .username)
export PGPASSWORD=$(echo "$SECRET_JSON" | jq -r .password)
export PGHOST=$(echo "semanticdb.cxc6qewmy2oa.us-east-1.rds.amazonaws.com" | jq -r .host)
export PGPORT=$(echo "5432" | jq -r .port)
export PGDATABASE=$(echo "semanticdb" | jq -r .dbname)

# === Connect using psql ===
echo "Connecting to PostgreSQL at $PGHOST:$PGPORT..."
psql


#!/bin/bash

# === Configuration ===
SECRET_NAME="semantic-search-db-credentialsed"  # Replace with your secret name
REGION="us-east-1"                    # Replace with your region
PGHOST="semanticdb.cxc6qewmy2oa.us-east-1.rds.amazonaws.com"
PGPORT="5432"
PGDATABASE="semanticdb"

# === Check dependencies ===
if ! command -v aws &> /dev/null; then
  echo "AWS CLI not found. Please install and configure it."
  exit 1
fi

if ! command -v jq &> /dev/null; then
  echo "jq not found. Please install jq (JSON processor)."
  exit 1
fi

if ! command -v psql &> /dev/null; then
  echo "psql not found. Please install the PostgreSQL client."
  exit 1
fi

# === Retrieve secret from AWS Secrets Manager ===
echo "Fetching PostgreSQL credentials from AWS Secrets Manager..."
SECRET_JSON=$(aws secretsmanager get-secret-value \
  --secret-id "$SECRET_NAME" \
  --region "$REGION" \
  --query SecretString \
  --output text)

if [ $? -ne 0 ]; then
  echo "Failed to fetch secret from AWS."
  exit 1
fi

# === Parse credentials ===
export PGUSER=$(echo "$SECRET_JSON" | jq -r .username)
export PGPASSWORD=$(echo "$SECRET_JSON" | jq -r .password)

# === Connect using psql ===
echo "Connecting to PostgreSQL at $PGHOST:$PGPORT..."
psql "host=$PGHOST port=$PGPORT dbname=$PGDATABASE user=$PGUSER password=$PGPASSWORD"
