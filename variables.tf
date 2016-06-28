variable "public_key_path" {
  description = "Path to the SSH public key to be used for authentication."
  default = "~/.ssh/terraform.pub"
}

variable "private_key_path" {
  description = "Path to the SSH private key to be used for authentication."
  default = "~/.ssh/terraform"
}

variable "key_name" {
  description = "Desired name of AWS key pair"
  default = "deployer"
}

variable "aws_region" {
  description = "AWS region to launch servers."
  default = "eu-west-1"
}

variable "aws_amis" {
  default = {
    eu-west-1 = "ami-38049f4b"
  }
}
