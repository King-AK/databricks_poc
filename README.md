# databricks_poc
Dummy repo to play around with Databricks

## Create workspace

Login to Azure CLI

```bash
az login
```

Login to Azure CLI

```bash
RG_NAME="insert rg name"
SUBSCRIPTION_ID="insert subscription id"
WORKSPACE_NAME="test-workspace"
DEPLOYMENT_NAME=""
```

Deploy infra

```bash
az deployment group create --resource-group $RG_NAME \
                           --subscription $SUBSCRIPTION_ID \
                           --template-file arm-iac/workspace.json \
                           --parameters workspaceName=$WORKSPACE_NAME
``` 


## Delete workspace

Remove infra

```bash
az resource delete --resource-group $RG_NAME \
                   --subscription $SUBSCRIPTION_ID \
                   --name $WORKSPACE_NAME \
                   --resource-type "Microsoft.Databricks/workspaces"
``` 