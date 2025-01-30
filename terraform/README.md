# Terraform

If you need to install Terraform: https://developer.hashicorp.com/terraform/install

Terraform will create the resuource group with a randomly generated number so that you can run this multiple times.

Log into Azure and export your subscription ID and tenant ID
```bash
export TF_VAR_subscription_id=$(az account show --query id -o tsv)
export TF_VAR_tenant_id=$(az account show --query tenantId -o tsv)
```

From the src/main/terraform directory, run the following commands to create the resources in Azure:

```bash
terraform init
terraform plan -out quarkusinazure.plan
terraform apply "quarkusinazure.plan"
 ```

Don't forget to destroy your resources when you are done, and note that it can take a while for CosmosDB to delete:

```bash 
terraform destroy
```
