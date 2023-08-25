resource "aws_launch_template" "tw_launch_template" {
  name = "tw-launch-template"
  block_device_mappings {
    device_name = "/dev/sda1"

    ebs {
      volume_size = 8
    }
  }

  image_id      = data.aws_ami.ubuntu.id
  instance_type = "t2.micro"
  key_name      = var.aws_key_name
  lifecycle {
    create_before_destroy = true
  }
  network_interfaces {
    subnet_id                   = var.aws_subnet_id
    associate_public_ip_address = true
  }
  # vpc_security_group_ids = [var.aws_sg_id]
  tag_specifications {
    resource_type = "instance"

    tags = {
      Name = "tw-resource"
    }
  }
  iam_instance_profile {
    name = var.aws_ec2_codedeploy_instance_profile_name
  }
  user_data = filebase64("./script/script.sh")
}

data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["099720109477"] # Canonical
}