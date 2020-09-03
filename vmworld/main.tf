provider "aws" {
    version = "2.69.0"
    region="us-west-1"
}

variable "instance_type" {
  description = "AWS instance type"
  default     = "t2.micro"
}

variable "myTag" {
  description = "My Input Tag"
  default = "terraform-test"
}

resource "aws_instance" "machine1" {
    ami           = "ami-0a63cd87767e10ed4"
    instance_type = var.instance_type
    availability_zone = "us-west-1b"
    tags = {
      "type" = var.myTag
    }
}

resource "aws_instance" "machine2" {
    ami           = "ami-0a63cd87767e10ed4"
    instance_type = var.instance_type
    availability_zone = "us-west-1b"
    tags = {
      "type" = var.myTag
    }
}

