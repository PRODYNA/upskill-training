# Terraform for creating Azure resources

## Content

Installs the following to a given Subscription

### Azure Container Registry (ACR)

Create an ACR with the following features

* Public facing
* Admin account enabled

## Azure Kubernetes Service (AKS)

Create an AKS with the following features

* Public facing
* No AD integration

## Run terraform to create the resources in azure

## Steps

1. **Login to Azure**

```bash
az login
```

2. **Switch to the right subscription**

```bash
az account set --subscription cd4b198a-f112-461a-a3c3-d3d33c059e5caz
```

3. **Run terraform plan**

```bash
terraform plan -o planfile -var 'project_name=<shortName>' -var 'resource_group_name=<resourceGroupName>'
```

4. **Run terraform apply**

```bash
terraform apply planfile
```

After terraform has finished the run you should see the resources in your resource group in the Azure portal.
