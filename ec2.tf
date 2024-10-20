resource "aws_instance" "debian_ec2" {
  ami             = "ami-064519b8c76274859"
  instance_type   = "t2.micro"
  key_name        = "key_terraform"
  security_groups = ["allow_ssh", "allow_http", "allow_egress"]

  associate_public_ip_address = true

  root_block_device {
    volume_size           = 20
    volume_type           = "gp2"
    delete_on_termination = true
  }

  user_data = file("script.sh")

  tags = {
    Name = "debian_ec2"
  }
}
