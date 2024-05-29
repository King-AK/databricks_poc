# databricks_poc
Repo to play around with Databricks.
* Deploys Data Lake infrastructure using Terraform 
* Loads a Kaggle dataset [NFL Play-by-Play 2009-2018](https://www.kaggle.com/datasets/maxhorowitz/nflplaybyplay2009to2016) into object storage
* Databricks jobs coordinate movement of data through the lake using Scala and Python

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