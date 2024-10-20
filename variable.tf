variable "projeto" {
  description = "Desafio_DevOps"
  type        = string
  default     = "VExpenses"
}

variable "candidato" {
  description = "Nome do candidato"
  type        = string
  default     = "Eduardo_Victor_de_Oliveira_Goncalves"
}

variable "region" {
  description = "A região AWS onde os recursos serão criados"
  type        = string
  default     = "us-east-1"
}

variable "vpc_cidr" {
  description = "CIDR para a VPC"
  type        = string
  default     = "10.110.0.0/16"
}

variable "subnet_a_cidr" {
  description = "CIDR para a Subnet A"
  type        = string
  default     = "10.110.1.0/24"
}

variable "subnet_b_cidr" {
  description = "CIDR para a Subnet B"
  type        = string
  default     = "10.110.2.0/24"
}
