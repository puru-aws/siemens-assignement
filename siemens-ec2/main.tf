provider "aws" {
  region = var.region
}

data "aws_ami" "latest_ubuntu" {
  most_recent = true
  owners      = ["099720109477"]

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"]
  }
}

resource "aws_security_group" "app_sg" {
  name   = format("%s-app-sg", var.name)
  vpc_id = var.vpc_id

  ingress {
    from_port   = var.app_port
    to_port     = var.app_port
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port   = "22"
    to_port     = "22"
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port   = "0"
    to_port     = "65535"
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    Name = "${var.name}"
  }
}

resource "aws_instance" "app" {
  ami                         = data.aws_ami.latest_ubuntu.id
  instance_type               = "p3.2xlarge"
  subnet_id                   = var.ec2_subnet
  vpc_security_group_ids      = [aws_security_group.app_sg.id]
  associate_public_ip_address = true
  user_data                   = file("init.sh")
  key_name                    = var.key_pair
  iam_instance_profile        = aws_iam_instance_profile.ec2_instance_profile1.id
  tags = {
    Name = "${var.name}"
  }
}


resource "aws_iam_role_policy_attachment" "test" {
  role       = aws_iam_role.ec2_s3_role_siemens.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonS3ReadOnlyAccess"
}

resource "aws_iam_role" "ec2_s3_role_siemens" {
  name = "ec2_s3_role_siemens"
  assume_role_policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Effect" : "Allow",
        "Principal" : {
          "Service" : "ec2.amazonaws.com"
        },
        "Action" : "sts:AssumeRole"
      }
    ]
  })
}

resource "aws_iam_instance_profile" "ec2_instance_profile1" {
  name = "ec2-instance-profile1"
  role = aws_iam_role.ec2_s3_role_siemens.name
}
resource "aws_s3_bucket_object" "object" {
  bucket   = var.bucket_name
  for_each = fileset("../docker/", "**")
  key      = each.value
  source   = "../docker/${each.value}"
}


output "public_ip" {
  value = aws_instance.app.public_ip
}
output "instance_type" {
  value = "Instance type that supports single Tesla V100 GPU : ${aws_instance.app.instance_type} "
}
