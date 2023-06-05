STORAGE_ACCOUNT_NAME=$1
CONTAINER_NAME=$2

# Copy local data to blob storage
az storage copy -s ./data \
                -d "https://$STORAGE_ACCOUNT_NAME.blob.core.windows.net/$CONTAINER_NAME/raw" \
                --recursive