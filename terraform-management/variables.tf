##############################################################################################################
#
# FortiGate CNF - Demo
# Management and Analytics - FortiManager and FortiAnalyzer
#
##############################################################################################################

# Prefix for all resources created for this deployment in Microsoft Azure
variable "PREFIX" {
  description = "Added name to each deployed resource"
}

variable "REGION" {
  description = "AWS region"
}

variable "USERNAME" {
  description = "Default username for the FortiGate-VM in AWS is admin"
  default     = "admin"
}

variable "PASSWORD" {
  description = "Default password for admin user is the instance id"
  default     = ""
}

//AWS Configuration
variable "ACCESS_KEY" {}
variable "SECRET_KEY" {}

//  Existing SSH Key on the AWS
variable "KEY_PAIR" {
  default = ""
}

locals {
  az1 = "${var.REGION}a"
  az2 = "${var.REGION}b"
}

##############################################################################################################
# FortiManager and FortiAnalyzer license type
##############################################################################################################

variable VERSION {
  default = "7.2.2"
}

variable "FMG_BYOL_LICENSE_FILE" {
  default = ""
}

variable "FAZ_BYOL_LICENSE_FILE" {
  default = ""
}

variable "FMG_BYOL_FLEXVM_LICENSE" {
  default = ""
}

variable "FMG_SSH_PUBLIC_KEY_FILE" {
  default = ""
}

variable "FAZ_SSH_PUBLIC_KEY_FILE" {
  default = ""
}

// License Type to create FortiGate-VM
// Provide the license type for FortiGate-VM Instances, either byol or payg.
variable "license_type" {
  default = "byol"
}

// instance architecture
// Either x86_64
variable "arch" {
  default = "x86_64"
}

variable "fmglocator" {
  type = map(any)
  default = {
    payg = {
      x86_64 = "FortiAnalyzer VM64-AWSONDEMAND "
    },
    byol = {
      x86_64 = "FortiAnalyzer VM64-AWS "
    }
  }
}

data "aws_ami" "fmg_ami" {
  most_recent = true
  owners      = ["679593333241"] # Fortinet

  filter {
    name   = "name"
    values = ["${var.fmglocator[var.license_type][var.arch]}*${var.VERSION}*"]
  }

  filter {
    name   = "architecture"
    values = [var.arch]
  }
}

variable "fmg_vmsize" {
  default = "m5.large"
}

variable "faz_vmsize" {
  default = "m5.large"
}

variable "lnx_vmsize" {
  default = "t4g.micro"
}

##############################################################################################################
# Static variables
##############################################################################################################

// VPC for Inspection VPC
variable "vpccidr" {
  default = "10.0.0.0/24"
}

variable "publiccidraz1" {
  default = "10.1.0.0/24"
}

variable "publiccidraz2" {
  default = "10.1.1.0/24"
}

variable "fmg_ip" {
  default = "10.1.0.10"
}

variable "faz_ip" {
  default = "10.1.0.20"
}

variable "gateway" {
  default = "10.1.0.1"
}

variable "subnetmask" {
  default = "255.255.255.0"
}

variable "fortinet_tags" {
  type = map(string)
  default = {
    publisher : "Fortinet",
    template : "FortiGate CNF - Management and Analytics"
  }
}
