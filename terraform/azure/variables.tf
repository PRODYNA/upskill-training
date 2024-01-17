variable "environment" {
  type    = string
  default = "dev"
}

variable "project_name" {
  type    = string
  default = "project"
}

variable "resource_group_name" {
  type = string
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
      max_count = 1
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