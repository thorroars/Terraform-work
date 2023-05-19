variable "region" {
   type = string
   default = "ap-south-1"
}

variable "access_key" {
   type = string
   default = "AKIAV3IUDZ2JIXOONZ6U"
}

variable "secret_key" {
   type = string
   default = "lWZ9laxGza40P4EoXzUrgNk65Iyw024u/k7/txiP"
}

variable "instance_type" {
   type = string
   default = "t2.micro"
}

variable "ami" {
   type = string
   default = "ami-022d03f649d12a49d"
}

variable "cidr_vpc" {
   type = string
   default = "10.0.0.0/16"
}

variable "subnet_cidr" {
   type = string
   default = "10.0.1.0/24"
}
variable "subnet_cidr-02" {
   type = string
   default = "10.0.2.0/24"
}