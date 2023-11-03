variable "aws_access_key" {
description = "The AWS access key."
}

variable "aws_secret_key" {
description = "The AWS access secret."
}

variable "region" {
description = "The AWS region."
default = "eu-west-1"
}

variable "prefix" {
  default = "fortigatecnf"
  description = "The name of our org, i.e. examplecom."
  }

variable "environment" {
  default = "dev"
  description = "The name of the environment."
 }
variable "CNF-ENDPOINT" {
  default = ""
}

variable "fazsize" {
  default = "m5.2xlarge"
}

variable "fazami" {
  default = "ami-0155cf8b704ed1b19"
}

variable "bootstrap_fazvm" {
  // Change to your own path
  type    = string
  default = "fazconfig.conf"
}

variable "faz_flextoken" {
  type = string
  description = "Paste your FortiAnalyzer Flex token ID"
}

variable "faz_hostname" {
  type = string
  default = "FAZ-VM-AWS"
}

variable "faz_adminpassword" {
  type = string
  default = "fortinet"
}
