variable "region" {
  type        = string
  description = "Region which the resources are deployed"
  default     = "us-east-1"
}
variable "name" {
  type        = string
  description = "Name for the EC2"
  default     = "Ansible"
}
variable "vpc_id" {
  description = "VPC ID for EC2 deployement"
  default     = "vpc-095fe9d44ee80db83"
}
variable "ec2_subnet" {
  type        = string
  description = "Public subnet to deploy EC2"
  default     = "subnet-05971958d7636b9ea"
}
