##############################################################################################################
#
# FortiGate CNF - Demo
# Management and Analytics - FortiManager and FortiAnalyzer
#
##############################################################################################################
# FortiManager
##############################################################################################################

resource "aws_eip" "fmgpip" {
  depends_on        = [aws_instance.fmgvm]
  vpc               = true
  network_interface = aws_network_interface.fmgnicext.id
  tags = {
    Name = "${var.PREFIX}-fmg-pip"
  }
}

resource "aws_network_interface" "fmgnicext" {
  description = "${var.PREFIX}-fmg-external"
  subnet_id   = aws_subnet.publicsubnetaz1.id
  private_ips = [var.fmg_ip]
  tags = {
    Name = "${var.PREFIX}-fmg-nic-ext"
  }
}

resource "aws_network_interface_sg_attachment" "fmgnicextsg" {
  depends_on           = [aws_network_interface.fmgnicext]
  security_group_id    = aws_security_group.allow_all.id
  network_interface_id = aws_network_interface.fmgnicext.id
}

resource "aws_instance" "fmgvm" {
  //it will use region, architect, and license type to decide which ami to use for deployment
  ami               = data.aws_ami.fmg_ami.id
  instance_type     = var.fmg_vmsize
  availability_zone = local.az1
  key_name          = var.KEY_PAIR
  user_data = templatefile("${path.module}/customdata-fmg.tftpl", {
    fmg_csp            = "aws"
    fmg_vm_name        = "${var.PREFIX}-fmg-vm"
    fmg_license_file   = var.FMG_BYOL_LICENSE_FILE
    fmg_username       = var.USERNAME
    fmg_password       = var.PASSWORD
    fmg_ssh_public_key = var.FMG_SSH_PUBLIC_KEY_FILE
    fmg_ipaddr         = var.fmg_ip
    fmg_mask           = var.subnetmask
    fmg_gw             = var.gateway
  })

  root_block_device {
    volume_type = "standard"
    volume_size = "2"
  }

  ebs_block_device {
    device_name = "/dev/sdb"
    volume_size = "30"
    volume_type = "standard"
  }

  network_interface {
    network_interface_id = aws_network_interface.fmgnicext.id
    device_index         = 0
  }

  tags = {
    Name = "${var.PREFIX}-fmg-vm"
  }
}

data "aws_network_interface" "fmgnicext" {
  id = aws_network_interface.fmgnicext.id
}
