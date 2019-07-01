data "http" "myip" {
  url = "http://ipv4.icanhazip.com"
}
resource "aws_key_pair" "generated_key" {
  key_name   = "${var.aws_key_name}"
  public_key = "${file(var.pub_key)}"
}
resource "aws_security_group" "allow_ssh" {
  name        = "allow_tls"
  description = "Allow TLS inbound traffic"


  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["${chomp(data.http.myip.body)}/32"]
  }
}
resource "aws_instance" "web" {
  ami           = "ami-06832d84cd1dbb448"
  instance_type = "t2.micro"
  key_name      = "${aws_key_pair.generated_key.key_name}"
  security_groups = [
    "${aws_security_group.allow_ssh.name}"
  ]

  connection {
    user = "${var.instance_user}"
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
      "sudo bash /tmp/remote-init.sh"
    ]
  }
}
