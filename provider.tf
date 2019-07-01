variable "pub_key" {}
variable "pvt_key" {}
variable "ssh_fingerprint" {}
variable "aws_access_key_id" {}
variable "aws_secret_access_key" {}
variable "aws_key_name" {}
variable "instance_user" {}
variable "project_dir" {}
variable "remote_project_dir" {
  default = "project"
}

provider "aws" {
  region = "ap-south-1"
  access_key = "${var.aws_access_key_id}"
  secret_key = "${var.aws_secret_access_key}"
}
