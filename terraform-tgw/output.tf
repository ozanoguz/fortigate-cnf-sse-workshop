output "Jumpbox_Public_Ip" {
   value = "${aws_instance.jumpbox.public_ip}"
}

# Output the public IP address of the FortiAnalyzer instance
output "FortiAnalyzer_Public_IP" {
  value = "${aws_instance.fazvm.public_ip}"
}

output "FortiAnalyzer_Login_Password" {
   value = "${var.faz_adminpassword}"
}
