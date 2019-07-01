variable "do_token" {}
variable "pub_key" {}
variable "pvt_key" {}
variable "ssh_fingerprint" {}
variable "aws_access_key_id" {}
variable "aws_secret_access_key" {}
variable "project_dir" {}
variable "remote_project_dir" {
  default = "project"
}

provider "digitalocean" {
  token = "${var.do_token}"
}
