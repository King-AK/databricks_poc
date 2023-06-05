# databricks_poc
Dummy repo to play around with Databricks

## Deploy Infra

Login to Azure CLI

```bash
az login
```

Set Env Vars

```bash
RG_NAME="insert rg name"
SUBSCRIPTION_ID="insert subscription id"
WORKSPACE_NAME="insert databricks workspace name"
KEYVAULT_NAME="insert keyvault name"
STORAGE_ACCOUNT_NAME="insert storage account name"
STORAGE_CONTAINER_NAME="insert storage container name"
TENANT_ID="insert azure tenant id"
```

Deploy infra

```bash
bash scripts/deploy-resources.sh $RG_NAME $SUBSCRIPTION_ID $KEYVAULT_NAME $WORKSPACE_NAME $STORAGE_ACCOUNT_NAME
``` 

After this, log into Azure Portal and access Databricks workspace. View the Databricks Repos, and observe that it is empty.


Create a Git token and set an environment variable for it

```bash
export GITHUB_TOKEN="github token"
```

Configure the Databricks workspace

```bash
bash scripts/configure_databricks_workspace.sh $WORKSPACE_NAME $KEYVAULT_NAME $RG_NAME $STORAGE_ACCOUNT_NAME $TENANT_ID
``` 

Upload data to storage account

```bash
bash scripts/copy_data_to_blob_storage.sh $STORAGE_ACCOUNT_NAME $STORAGE_CONTAINER_NAME
```

## Delete workspace

Collect the service princpal app id from the portal

Remove infra and clean up resources

```bash
bash scripts/remove-resources.sh $RG_NAME $SUBSCRIPTION_ID $KEYVAULT_NAME $WORKSPACE_NAME $STORAGE_ACCOUNT_NAME "<SERVICE PRINCPAL APP_ID>"
``` 