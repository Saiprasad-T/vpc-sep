variable "ami_id" {
  type    = string
  default = "ami-0055977a6e828a4f4"
}

variable "project" { #for vpc
  type    = string
  default = "roboshop"
}

variable "environment" { #for vpc
  type    = string
  default = "dev"
}
