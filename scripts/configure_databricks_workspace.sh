WORKSPACE_NAME=$1
KEYVAULT_NAME=$2


# Set up venv
rm -rf ./venv
python3.10 -m venv ./venv
source ./venv/bin/activate

# Install requirements
requirements_file="requirements.txt"
pip install --upgrade pip
pip install wheel
pip install setuptools
echo "Installing requirements from ${requirements_file}..."
pip install -r ${requirements_file}
echo "Installed requirements from ${requirements_file}..."

# Fetch AAD token scoped for Databricks use
export DATABRICKS_AAD_TOKEN=$(az account get-access-token --resource 2ff814a6-3304-4ab8-85cb-cd0e6f879c1d | jq -r .accessToken)

# Collect Resource Information for Workspace and Keyvault
DATABRICKS_URL=$(az databricks workspace show --name $WORKSPACE_NAME --resource-group $RG_NAME | jq -r .workspaceUrl)
KV_RESOURCE_ID=$(az keyvault show --name $KEYVAULT_NAME --resource-group $RG_NAME | jq -r .id)
KV_DNS_NAME=$(az keyvault show --name $KEYVAULT_NAME --resource-group $RG_NAME | jq -r .properties.vaultUri)

# Configure Databricks CLI using AAD token
databricks configure --aad-token --host "https://$DATABRICKS_URL"

# Create Databricks Secret Scope for KV
databricks secrets create-scope --scope-backend-type AZURE_KEYVAULT \
                                --resource-id $KV_RESOURCE_ID \
                                --dns-name $KV_DNS_NAME \
                                --scope $KEYVAULT_NAME \
                                --initial-manage-principal users

# TODO: Create Databricks Repo
# 