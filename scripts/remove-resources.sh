RG_NAME=$1
SUBSCRIPTION_ID=$2
KEYVAULT_NAME=$3
WORKSPACE_NAME=$4

# Delete Azure Keyvault
echo "Deleting Azure Keyvault $KEYVAULT_NAME ..."
az resource delete --resource-group $RG_NAME \
                   --subscription $SUBSCRIPTION_ID \
                   --name $KEYVAULT_NAME \
                   --resource-type "Microsoft.KeyVault/vaults"
echo "Purging Azure Keyvault $KEYVAULT_NAME ..."
az keyvault purge --subscription $SUBSCRIPTION_ID \
                  --name $KEYVAULT_NAME

# Delete Azure Databricks Workspace
echo "Deleting Azure Databricks Workspace $WORKSPACE_NAME ..."
az resource delete --resource-group $RG_NAME \
                   --subscription $SUBSCRIPTION_ID \
                   --name $WORKSPACE_NAME \
                   --resource-type "Microsoft.Databricks/workspaces"