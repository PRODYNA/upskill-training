# Wait two minutes after creation of container registry
resource "null_resource" "waitcr" {
  provisioner "local-exec" {
    command = "sleep 120"
  }
  depends_on = [
    azurerm_container_registry.main
  ]
}

# Build container image insize of ACR
resource "null_resource" "build_web" {
  provisioner "local-exec" {
    command = "az acr build -r ${azurerm_container_registry.main.name} -t sample:1.0 ../../sample"
  }
  depends_on = [
    null_resource.waitcr
  ]
}
