# You need to edit the yaml files in the assets/sample-kustomize directories
# - (prod/dev).example.com needs to match your dns name for the ingress
# - the registry/sample image needs to be replaced with your image name in acr
# (could be done dynamically in a pipeline with kustomize edit set image <name>:<tag>)

# # Prepare namespace for the application
# resource "kubernetes_namespace" "sample-kustomize" {
#   metadata {
#       name = "sample-kustomize"
#   }
# }

# # Deploy the application
# resource "null_resource" "sample-kustomize" {
#   provisioner "local-exec" {
#     command="kubectl apply -k assets/kustomize/overlays/dev/"
#   }
#   depends_on = [
#     kubernetes_namespace.sample-kustomize
#   ]
# }
