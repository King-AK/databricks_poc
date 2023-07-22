WORKSPACE_NAME=$1
RG_NAME=$2
if [ -z ${GITHUB_TOKEN+x} ]; then 
    echo "ENV VAR GITHUB_TOKEN is unset. Please set this ENV var"
    exit 1 
fi

DATABRICKS_APP_ID="2ff814a6-3304-4ab8-85cb-cd0e6f879c1d"

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
export DATABRICKS_AAD_TOKEN=$(az account get-access-token --resource $DATABRICKS_APP_ID | jq -r .accessToken)

# Collect Resource Information for Workspace
DATABRICKS_URL=$(az databricks workspace show --name $WORKSPACE_NAME --resource-group $RG_NAME | jq -r .workspaceUrl)
DATABRICKS_HOST="https://$DATABRICKS_URL"

# Configure Databricks CLI using AAD token
echo "Configuring Databricks CLI connection information ..."
databricks configure --aad-token --host $DATABRICKS_HOST

# Use Terraform to further configure Workspace, including Repos, Secret Scopes, Clusters
cd terraform-iac
terraform init
terraform plan
terraform apply -auto-approve
cd ..

