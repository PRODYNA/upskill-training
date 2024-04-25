## Wait two minutes after creation of container registry
#resource "terraform_data" "waitcr" {
#  provisioner "local-exec" {
#    command = "sleep 120"
#  }
#  depends_on = [
#    azurerm_container_registry.main
#  ]
#}
#
## Build container image insize of ACR
# resource "terraform_data" "build_sample" {
#   provisioner "local-exec" {
#     command = "az acr build -r ${azurerm_container_registry.main.name} -t ${local.image.repository}:${local.image.tag} ../../sample -g ${azurerm_resource_group.main.name}"
#   }
#  depends_on = [
#    terraform_data.waitcr
#  ]
# }
