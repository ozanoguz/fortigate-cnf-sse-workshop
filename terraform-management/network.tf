##############################################################################################################
#
# FortiGate CNF
# Transit Gateway setup
#
##############################################################################################################
# VPC Management
##############################################################################################################
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.vpc-management.id
  tags = {
    Name = "${var.PREFIX}-management-igw"
  }
}

resource "aws_vpc" "vpc-management" {
  cidr_block           = var.vpccidr
  enable_dns_support   = true
  enable_dns_hostnames = true
  instance_tenancy     = "default"
  tags = {
    Name = "${var.PREFIX}-vpc-management"
  }
}

resource "aws_subnet" "publicsubnetaz1" {
  vpc_id            = aws_vpc.vpc-management.id
  cidr_block        = var.publiccidraz1
  availability_zone = local.az1
  tags = {
    Name = "${var.PREFIX}-subnet-management-az1"
  }
}

resource "aws_subnet" "publicsubnetaz2" {
  vpc_id            = aws_vpc.vpc-management.id
  cidr_block        = var.publiccidraz2
  availability_zone = local.az2
  tags = {
    Name = "${var.PREFIX}-subnet-management-az2"
  }
}

resource "aws_route_table" "publicrt" {
  vpc_id = aws_vpc.vpc-management.id

  tags = {
    Name = "${var.PREFIX}-rt-management-public"
  }
}

resource "aws_route" "publicroute" {
  route_table_id         = aws_route_table.publicrt.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.igw.id
}

resource "aws_route_table_association" "publicassociateaz1" {
  subnet_id      = aws_subnet.publicsubnetaz1.id
  route_table_id = aws_route_table.publicrt.id
}

resource "aws_route_table_association" "publicassociateaz2" {
  subnet_id      = aws_subnet.publicsubnetaz2.id
  route_table_id = aws_route_table.publicrt.id
}

##############################################################################################################
# VPC Security Groups
##############################################################################################################
resource "aws_security_group" "public_allow" {
  name        = "Management Public Allow"
  description = "Management Public Allow traffic"
  vpc_id      = aws_vpc.vpc-management.id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "6"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "6"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 8443
    to_port     = 8443
    protocol    = "6"
    cidr_blocks = ["0.0.0.0/0"]
  }


  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.PREFIX}-sg-management-public-allow"
  }
}

resource "aws_security_group" "allow_all" {
  name        = "Allow All"
  description = "Allow all traffic"
  vpc_id      = aws_vpc.vpc-management.id

  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.PREFIX}-sg-management-allow-all"
  }
}
