variable "project" {      #for vpc
    type = string
    default = "roboshop"
}

variable "environment" {     #for vpc
    type = string
    default = "dev"
}

variable "public_subnet_cidrs" {
  default = ["10.0.11.0/24", "10.0.12.0/24"]
}

variable "private_subnet_cidrs" {
  default = ["10.0.31.0/24", "10.0.32.0/24"]
}

variable "availability_zones" {
  default = ["us-east-1a", "us-east-1b"]
}

