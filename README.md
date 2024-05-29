# databricks_poc
Repo to play around with Databricks workspace configuration. Deploys Data Lake infrastructure using Terraform .

## Deploy Infra to Azure with Terraform

Login to Azure CLI

```bash
az login
```

Run terraform
```bash
cd terraform
terraform init
terraform apply -auto-approve -var-file=environment/poc.tfvars
```

## Clean up Infra

```bash
terraform destroy -auto-approve -var-file=environment/poc.tfvars
```