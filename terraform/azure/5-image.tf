# ## Wait two minutes after creation of container registry
# resource "time_sleep" "wait_120_seconds" {
#   create_duration = "120s"

#   depends_on = [
#     azurerm_container_registry.main
#   ]

#   triggers = {
#     acr = azurerm_container_registry.main.id
#   }
# }

# # Build container image insize of ACR
# resource "terraform_data" "build_sample" {
#   provisioner "local-exec" {
#     command = "az acr build -r ${azurerm_container_registry.main.name} -t ${local.image.repository}:${local.image.tag} ../../sample -g ${azurerm_resource_group.main.name}"
#   }
#   depends_on = [
#     time_sleep.wait_120_seconds
#   ]
# }
