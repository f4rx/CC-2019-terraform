variable "user_name" {}
variable "user_password" {}
variable "domain_name" {}
variable "project_id" {}
variable "region" {}
variable "az_zone" {}
variable "volume_type" {}
variable "public_key" {}
variable "server_count" {
  default = 2
}
variable "server_name" {
  default = "server"
}



variable "hdd_size" {
  default = "5"
}

variable "grafana_password" {
  default = "secret_password"
}
