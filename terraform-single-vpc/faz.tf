# Create a security group for FortiAnalyzer
resource "aws_security_group" "fortianalyzer_sg" {
  name        = "fortianalyzer-sg"
  description = "Security group for FortiAnalyzer"
  vpc_id      = "${aws_vpc.main.id}"

  # Add rules for incoming traffic
  # You may need to adjust these rules according to your requirements
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 514
    to_port     = 514
    protocol    = "udp"
    cidr_blocks = ["0.0.0.0/0"]
  }

    ingress {
    from_port   = 514
    to_port     = 514
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Add rules for outgoing traffic
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# Allocate an Elastic IP for the FortiAnalyzer instance
resource "aws_eip" "fortianalyzer_eip" {
  depends_on        = [aws_instance.fazvm]
  network_interface = aws_network_interface.faz_eth0.id
}

resource "aws_network_interface" "faz_eth0" {
  description = "fazvm-port1"
  subnet_id   = aws_subnet.subnet-public-3.id
}

resource "aws_network_interface_sg_attachment" "publicattachment" {
  depends_on           = [aws_network_interface.faz_eth0]
  security_group_id    = aws_security_group.fortianalyzer_sg.id
  network_interface_id = aws_network_interface.faz_eth0.id
}

resource "aws_instance" "fazvm" {
  //it will use region, architect, and license type to decide which ami to use for deployment
  ami               = var.fazami
  instance_type     = var.fazsize
  subnet_id = aws_subnet.subnet-public-3.id
  vpc_security_group_ids = [aws_security_group.fortianalyzer_sg.id]
  key_name          = "${aws_key_pair.jumpbox_key.key_name}"
  user_data = templatefile("${var.bootstrap_fazvm}", {
    faz_flextoken = "${var.faz_flextoken}"
    faz_adminpassword = "${var.faz_adminpassword}"
  })

  root_block_device {
    volume_type = "standard"
    volume_size = "5"
  }

  ebs_block_device {
    device_name = "/dev/sdb"
    volume_size = "80"
    volume_type = "standard"
  }

  //network_interface {
   // network_interface_id = aws_network_interface.faz_eth0.id
    //device_index         = 0
 // }

  tags = {
    Name = "FortiAnalyzer-VM"
  }
}
