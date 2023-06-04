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
WORKSPACE_NAME="test-workspace"
KEYVAULT_NAME="test-keyvault-342fgw"
DEPLOYMENT_NAME=""
```

Deploy infra

```bash
bash scripts/deploy-resources.sh $RG_NAME $SUBSCRIPTION_ID $KEYVAULT_NAME $WORKSPACE_NAME $STORAGE_ACCOUNT_NAME
``` 

After this, log into Azure Portal and access Databricks workspace. View the Databricks Repos, and observe that it is empty.

Configure the Databricks workspace

```bash
bash scripts/configure_databricks_workspace.sh $WORKSPACE_NAME $KEYVAULT_NAME $RG_NAME
``` 


## Delete workspace

Collect the service princpal app id from the portal

Remove infra and clean up resources

```bash
bash scripts/remove-resources.sh $RG_NAME $SUBSCRIPTION_ID $KEYVAULT_NAME $WORKSPACE_NAME $STORAGE_ACCOUNT_NAME "<SERVICE PRINCPAL APP_ID>"
``` 