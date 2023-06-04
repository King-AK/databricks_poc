RG_NAME=$1
SUBSCRIPTION_ID=$2
KEYVAULT_NAME=$3
WORKSPACE_NAME=$4
STORAGE_ACCOUNT_NAME=$5
SP_NAME="sp-databricks-poc"

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

# Grant account access to KV
USER_OBJ_ID=$(az ad signed-in-user show | jq -r .id)
az keyvault set-policy --name $KEYVAULT_NAME \
                       --secret-permissions all \
                       --object-id $USER_OBJ_ID

# Create SP, collect info, populate into KV 
az ad sp create-for-rbac --name $SP_NAME
APP_ID=$(az ad sp list --display-name $SP_NAME | jq -r .[0].appId)
SP_SECRET=$(az ad sp credential reset --id $APP_ID --display-name databricks-poc | jq -r .password)
echo "Created SP $SP_NAME with APP ID: $APP_ID ..."

az keyvault secret set --name sp-databricks-poc-app-id --value $APP_ID --vault-name $KEYVAULT_NAME
az keyvault secret set --name sp-databricks-poc-app-secret --value $SP_SECRET --vault-name $KEYVAULT_NAME


# Grant SP permissions to access KV, Blob Storage
az keyvault set-policy --name $KEYVAULT_NAME \
                       --secret-permissions all \
                       --spn $APP_ID

SAC_ID=$(az storage account show --name $STORAGE_ACCOUNT_NAME --resource-group $RG_NAME | jq -r .id)
az role assignment create --role "Storage Blob Data Contributor" \
                          --assignee $APP_ID \
                          --scope $SAC_ID
