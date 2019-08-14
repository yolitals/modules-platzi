provider "aws" {
    region="us-east-2"
}

resource "aws_security_group" "ssh_conection" {
  name        = var.sg_name
  dynamic "ingress"{
    for_each = var.ingress_rules
    content {
        from_port   = ingress.value.from_port
        to_port     = ingress.value.to_port
        protocol    = ingress.value.protocol
        cidr_blocks = ingress.value.cidr_blocks
    }  
  }

  
}
resource "aws_instance" "platzi-instance"{
    #ami = "ami-06fddf8d55d5ab5df"
    ami = var.ami_id
    instance_type = var.instance_type
    tags = var.tags
    security_groups = ["${aws_security_group.ssh_conection.name}"]
    connection {
      type     = "ssh"
      user     = "centos"
      private_key = "~/.ssh/packer-key"
    }
    provisioner "remote-exec" {
      inline = [
        "docker ps"
      ]
    }
}
