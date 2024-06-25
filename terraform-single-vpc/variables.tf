// AWS configuration
variable "aws_access_key" {
description = "Enter your Access Key"
}

variable "aws_secret_key" {
description = "Enter your Secret Key"
}

variable "region" {
description = "The AWS region."
default = "eu-west-1"
}

variable "prefix" {
  default = "FortiGateCNFLab"
  description = "The name of our org, i.e. examplecom."
  }

variable "environment" {
  default = "Dev"
  description = "The name of the environment."
 }

// GWLB endpoints. You should use name value, NOT the ID !!! 
variable "CNF-ENDPOINT" {
  default = ""
}

############################################################
################# FortiAnalyzer variables ##################
############################################################

// FortiAnalyzer-VM EC2 size
variable "fazsize" {
  default = "m5.2xlarge"
}

// FortiAnalyzer-VM EC2 AMI ID (v7.4.3 BYOL)
variable "fazami" {
  default = "ami-0e6e65a8b90731e39"
}

// FortiAnalyzer-VM hostname
variable "faz_hostname" {
  type = string
  default = "FAZ-VM-AWS"
}

// FortiAnalyzer-VM login password
variable "faz_adminpassword" {
  type = string
  default = "fortinet"
}
