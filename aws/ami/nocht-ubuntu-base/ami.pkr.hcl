source "amazon-ebs" "ubuntu" {
  ami_name      = "nocht-ubuntu-base"
  instance_type = "t3.micro"
  region        = "eu-west-1"

  force_deregister = true
  force_delete_snapshot = true
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
  name = "{{ uuidv4 }}"
  sources = [
    "source.amazon-ebs.ubuntu"
  ]

  provisioner "ansible" {
    user                   = "ubuntu"
    playbook_file          = "${abspath(path.root)}/configuration/playbook.yml"
    extra_arguments        = [
      "--extra-vars", "callback_whitelist=profile_tasks",
    ]
    ansible_ssh_extra_args = ["-oHostKeyAlgorithms=+ssh-rsa -oPubkeyAcceptedKeyTypes=+ssh-rsa"]
  }
}

