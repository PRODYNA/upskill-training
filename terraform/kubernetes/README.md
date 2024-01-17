# Deploy neccessary tools for kubernetes to the cluster

To deploy the folowing tools to the cluster:
- Ingress-Nginx controller via Helm (for ingress)
- Cert-Manager via Helm (for provisioning of TLS certificates)
- OpenTelemetry Collector via Helm (for collecting metrics)

we will use again terraform. You can use the same commands as previously to deploy the tools.

## Steps

1. **Login to Azure**

    Open your terminal and login to your Azure account using the Azure CLI:

    ```bash
    az login
    az account set --subscription cd4b198a-f112-461a-a3c3-d3d33c059e5caz
    ```

2. **Initialize Terraform**

    Run the following command in your terminal to download the necessary providers:

    ```bash
    terraform init
    ```

3. **Configure deployment**

    Terraform needs to know in which resource group it should deploy the Azure resources. To do so, create a `terraform.auto.tfvars` file and add the following content:

    ```ini
    resource_group_name="<resource_group_name>"
    project_name="<shortProjectNameWithOneWord>"
    ```

4. **Plan the deployment**

    Use the `terraform plan` command to see what Terraform will do before actually doing it:

    ```bash
    terraform plan
    ```

5. **Apply the changes**

    Apply the changes with the `terraform apply` command:

    ```bash
    terraform apply
    ```

    Confirm the apply when prompted.
