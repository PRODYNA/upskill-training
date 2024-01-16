# Terraform to install resources in Kubernetes

Installs the following components

* Ingress-Nginx controller via Helm
* Cert-Manager via Helm
* Our application via Helm

## Running

helm upgrade --install ingress-nginx ingress-nginx \
   --repo https://kubernetes.github.io/ingress-nginx \
   --namespace ingress-nginx \
   --create-namespace \
   --set defaultBackend.enabled=true \
   --set controller.service.annotations."service\.beta\.kubernetes\.io/azure-load-balancer-health-probe-request-path"=/healthz \
   --set controller.service.annotations."service\.beta\.kubernetes\.io/azure-load-balancer-resource-group"=aks-wks-matthias.hauber-ad320 \
   --set controller.service.loadBalancerIP="20.126.237.127"