variable "subscription_id" {
  type = string
}

variable "environment" {
  type    = string
  default = "dev"
}

variable "project_name" {
  type    = string
}

variable "cloudflare_zone_id" {
  type    = string
  default = "93c4d56b0f391d3d3baf00845877f42b" # should be in a secret
}

variable "resource_group_name" {
  type = string
}

variable "cloudflare_api_token" {
  type    = string
  default = "bxAwoD13eVTrF4oKXicCYxApw4EHUyYEvgakDcHd" # should be in a secret
}

variable "aks" {
  description = "aks properties"

  type = object({
    default_node_pool = object({
      vm_size   = string
      min_count = number
      max_count = number
    })
    version = object({
      control_plane = string
      node_pool     = string
    })
  })
  default = {
    default_node_pool = {
      vm_size   = "Standard_B2ms"
      min_count = 1
      max_count = 3
    }

    version = {
      control_plane = "1.28.3"
      node_pool     = "1.28.3"
    }
  }
}

variable "enable_ddos_protection" {
  description = "Enable DDoS protection on the AKS cluster Ingress IP"
  type        = bool
  default     = false
}
