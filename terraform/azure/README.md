# Terraform for installing Azure resources

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

## Running

Login to Azure using

```bash
az login
```

Switch to the right subscription

```bash
az account set --subscription cd4b198a-f112-461a-a3c3-d3d33c059e5caz account set --subscription 
```

Run terraform plan

```bash
terraform plan -o planfile
```

Run terraform apply

```bash
terraform apply planfile
```

After the run you should see an AKS in your resource group
