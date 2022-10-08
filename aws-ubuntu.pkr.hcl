source "amazon-ebs" "ubuntu" {
  ami_name      = "nocht-ubuntu"
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
  skip_create_ami = "${var.skip_publish}"
}

build {
  name = "nocht-ubuntu"
  sources = [
    "source.amazon-ebs.ubuntu"
  ]
  provisioner "ansible" {
    user                   = "ubuntu"
    playbook_file          = "configuration/playbook.yml"
    extra_arguments        = [
      "--extra-vars", "callback_whitelist=profile_tasks",
    ]
    ansible_ssh_extra_args = ["-oHostKeyAlgorithms=+ssh-rsa -oPubkeyAcceptedKeyTypes=+ssh-rsa"]
  }
}

