variable "instance_name" {
  description = "Value of the Name tag for the EC2 instance"
  type        = string
  default     = "LuxWebServer"
}

variable "ami" {
  description = "Value of the ami for the EC2 instance"
  type        = string
  default     = "ami-0a8b4cd432b1c3063"
}

variable "instance_type" {
  description = "Value of the EC2 instance type"
  type        = string
  default     = "t2.micro"
}

variable "aws_profile" {
  description = "Value of the AWS profile"
  type        = string
  default     = "terraform"
}

variable "aws_region" {
  description = "Value of the AWS default region"
  type        = string
  default     = "us-east-1"
}

variable "aws_key" {
  description = "SSH Public key path"
  type        = string
  default     = "../aws_lux.pub"
}