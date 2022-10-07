source "amazon-ebs" "ubuntu" {
  ami_name      = "learn-packer-linux-aws"
  instance_type = "t3.micro"
  region        = "eu-west-1"
  source_ami_filter {
    filters = {
      name                = "ubuntu/images/*ubuntu-*-22.04-amd64-server-*"
      root-device-type    = "ebs"
      virtualization-type = "hvm"
    }
    most_recent = true
    owners      = ["099720109477"]
  }
  ssh_username    = "ubuntu"
  skip_create_ami = true
}

build {
  name = "learn-packer"
  sources = [
    "source.amazon-ebs.ubuntu"
  ]
  provisioner "shell" {
    inline = [
      "echo test"
    ]
  }
  provisioner "ansible" {
    user                   = "ubuntu"
    playbook_file          = "configuration/playbook.yml"
    ansible_ssh_extra_args = ["-oHostKeyAlgorithms=+ssh-rsa -oPubkeyAcceptedKeyTypes=+ssh-rsa"]
  }
}

