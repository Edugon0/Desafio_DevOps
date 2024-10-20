resource "aws_security_group" "allow_ssh" {
  name        = "allow_ssh"
  description = "Remote access permission via Port 22 (SSH)"
  

  # Regras de entrada
  ingress {
    description      = "SSH from VPC"
    from_port        = 22
    to_port          = 22
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }


  tags = {
    Name = "allow_ssh"
  }
}

resource "aws_security_group" "allow_http" {
  name        = "allow_http"
  description = "Remote access permission via Port 80 (http)"
  

  # Regras de entrada
  ingress {
    description      = "HTTP from VPC"
    from_port        = 80
    to_port          = 80
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }


  tags = {
    Name = "allow_http"
  }
}


resource "aws_security_group" "allow_egress" {
  name        = "allow_egress"
  description = "Permission Egress"
  

    # Regras de saída
  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Name = "allow_egress"
  }
}