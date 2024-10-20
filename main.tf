terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "5.72.1"
    }
  }
}

provider "aws" {
  region = "us-east-1"
}


data "aws_ami" "debian12" {
  most_recent = true

  filter {
    name   = "name"
    values = ["debian-12-amd64-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["679593333241"]
}

resource "aws_vpc" "vpc_prod" {        
  cidr_block = "10.110.0.0/16"       
  enable_dns_hostnames = true        

  tags = {
    Name = "${var.projeto}-vpc"
  }
}

resource "aws_subnet" "sub_int_prod_a" {
  vpc_id            = aws_vpc.vpc_prod.id
  cidr_block        = "10.110.1.0/24"
  availability_zone = "us-east-1a"  # Ajustei para a zona correta

  tags = {
    Name = "sub_net_int_prod_a"
  }
}

resource "aws_subnet" "sub_int_prod_b" {
  vpc_id            = aws_vpc.vpc_prod.id
  cidr_block        = "10.110.2.0/24"
  availability_zone = "us-east-1b"  # Ajustei para a zona correta

  tags = {
    Name = "sub_net_int_prod_b"
  }
}

resource "aws_subnet" "sub_ext_prod_a" {  # Sub-rede externa A
  vpc_id            = aws_vpc.vpc_prod.id
  cidr_block        = "10.110.10.0/24"
  availability_zone = "us-east-1a"

  tags = {
    Name = "sub_net_ext_prod_a"
  }
}

resource "aws_subnet" "sub_ext_prod_b" {  # Sub-rede externa B
  vpc_id            = aws_vpc.vpc_prod.id
  cidr_block        = "10.110.11.0/24"
  availability_zone = "us-east-1b"

  tags = {
    Name = "sub_net_ext_prod_b"
  }
}

resource "aws_internet_gateway" "igw_prd" {  
  vpc_id = aws_vpc.vpc_prod.id               

  tags = {
    Name = "${var.projeto}-igw"
  }
}

resource "aws_route_table" "external_route_table" { 
  vpc_id = aws_vpc.vpc_prod.id                        

  tags = {
    Name = "${var.projeto}-external-route-table"             
  }
}

resource "aws_route" "rota_default_external" {  
  route_table_id         = aws_route_table.external_route_table.id  
  destination_cidr_block = "0.0.0.0/0"  
  gateway_id             = aws_internet_gateway.igw_prd.id    
}

resource "aws_route_table_association" "roteamento_externo_a" {
  subnet_id      = aws_subnet.sub_ext_prod_a.id
  route_table_id = aws_route_table.external_route_table.id
}

resource "aws_route_table_association" "roteamento_externo_b" {
  subnet_id      = aws_subnet.sub_ext_prod_b.id
  route_table_id = aws_route_table.external_route_table.id
}

resource "tls_private_key" "ec2_key" {
  algorithm = "RSA"
  rsa_bits  = 2048
}

resource "aws_key_pair" "ec2_key_pair" {
  key_name   = "${var.projeto}-${replace(var.candidato, " ", "_")}-key" 
  public_key = tls_private_key.ec2_key.public_key_openssh
}