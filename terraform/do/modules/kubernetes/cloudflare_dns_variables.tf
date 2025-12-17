variable "base_domain_name" {
  type = string
  description = "Base domain name"
  default = "kanibot.xyz"
}

variable "argo_cd_domain_name" {
  type = string
  description = "Domain name of the Argo CD server"
}
