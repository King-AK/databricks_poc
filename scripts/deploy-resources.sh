RG_NAME=$1
SUBSCRIPTION_ID=$2
KEYVAULT_NAME=$3
WORKSPACE_NAME=$4
STORAGE_ACCOUNT_NAME=$5

# Provision Azure Keyvault
echo "Provisioning Azure Keyvault $KEYVAULT_NAME ..."
az deployment group create --resource-group $RG_NAME \
                           --subscription $SUBSCRIPTION_ID \
                           --template-file arm-iac/keyvault.json \
                           --parameters keyVaultName=$KEYVAULT_NAME

# Provision Azure Databricks Workspace
echo "Provisioning Azure Databricks Workspace $WORKSPACE_NAME ..."
az deployment group create --resource-group $RG_NAME \
                           --subscription $SUBSCRIPTION_ID \
                           --template-file arm-iac/workspace.json \
                           --parameters workspaceName=$WORKSPACE_NAME

# Provision Azure Storage Account
echo "Provisioning Azure Storage Account $STORAGE_ACCOUNT_NAME ..."
az deployment group create --resource-group $RG_NAME \
                           --subscription $SUBSCRIPTION_ID \
                           --template-file arm-iac/storage.json \
                           --parameters storageAccountName=$STORAGE_ACCOUNT_NAME
