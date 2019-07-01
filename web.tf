resource "digitalocean_droplet" "web" {
  image  = "ubuntu-18-04-x64"
  name   = "web-1"
  region = "blr1"
  size   = "s-1vcpu-1gb"
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
  provisioner "remote-exec" {
    inline = [
      "apt update",
      "apt install -y nodejs npm",
      "sudo npm i -g yarn forever",
      "cd ~/${var.remote_project_dir}",
      "yarn install",
      "forever start -c 'yarn start' .",
      "echo 'REMOTE EXEC COMPLETE.'"
    ]
  }
}
