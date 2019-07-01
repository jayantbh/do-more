variable "do_token" {}
variable "pub_key" {}
variable "pvt_key" {}
variable "ssh_fingerprint" {}
variable "project_dir" {}
variable "remote_project_dir" {
  default = "project"
}

provider "digitalocean" {
  token = "${var.do_token}"
}
