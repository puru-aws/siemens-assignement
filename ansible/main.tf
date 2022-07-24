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
  instance_type               = "t2.2xlarge"
  subnet_id                   = var.ec2_subnet
  vpc_security_group_ids      = [aws_security_group.app_sg.id]
  associate_public_ip_address = true
  user_data                   = file("init.sh")
  key_name                    = var.key_pair
  iam_instance_profile        = aws_iam_instance_profile.ec2_instance_profile.id

  tags = {
    Name = "${var.name}"
  }
}

resource "aws_s3_bucket" "s3_bucket" {
  bucket = "siemens-assignement"
  acl    = "private"
}

resource "aws_iam_role_policy_attachment" "test" {
  role       = aws_iam_role.ec2_s3_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonS3ReadOnlyAccess"
}
resource "aws_iam_role" "ec2_s3_role" {
  name = "ec2_s3_role"
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

resource "aws_iam_instance_profile" "ec2_instance_profile" {
  name = "ec2-instance-profile"
  role = aws_iam_role.ec2_s3_role.name
}

resource "aws_s3_bucket_object" "object" {
  bucket   = aws_s3_bucket.s3_bucket.bucket
  for_each = fileset("/Users/prushok/Documents/siemens-assignement/ansible/playbooks", "**")
  key      = each.value
  source   = "/Users/prushok/Documents/siemens-assignement/ansible/playbooks/${each.value}"
}

output "public_ip" {
  value = aws_instance.app.public_ip
}
output "s3_bucket" {
  value = aws_s3_bucket.s3_bucket.bucket
}
output "ami_used" {
  value = "AMI with latest Ubuntu LTS : ${data.aws_ami.latest_ubuntu.id}"
}


