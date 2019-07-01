resource "digitalocean_droplet" "web" {
  image  = "ubuntu-18-04-x64"
  name   = "web-1"
  region = "blr1"
  size   = "s-6vcpu-16gb"
  ssh_keys = [
    "${var.ssh_fingerprint}"
  ]
  connection {
    user = "root"
    type = "ssh"
    private_key = "${file(var.pvt_key)}"
    timeout = "2m"
  }
  provisioner "remote-exec" {
    inline = [
      "mkdir -p ~/${var.remote_project_dir}"
    ]
  }
  provisioner "file" {
    source = "${var.project_dir}/",
    destination = "~/${var.remote_project_dir}"
  }
  provisioner "file" {
    source = "./remote-init.sh",
    destination = "/tmp/remote-init.sh"
  }
  provisioner "remote-exec" {
    inline = [
      "export AWS_ACCESS_KEY_ID=${var.aws_access_key_id}",
      "export AWS_SECRET_ACCESS_KEY=${var.aws_secret_access_key}",
      "bash /tmp/remote-init.sh"
    ]
  }
}
