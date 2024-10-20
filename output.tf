output "private_key" {
  description = "Chave privada para acessar a instância EC2"
  value       = tls_private_key.ec2_key.private_key_pem
  sensitive   = true
}

output "ec2_public_ip" {
  description = "Endereço IP público da instância EC2"
  value       = aws_instance.debian_ec2.public_ip
}

output "subnet_ids" {
  description = "IDs das sub-redes criadas"
  value = [
    aws_subnet.sub_int_prod_a.id,
    aws_subnet.sub_int_prod_b.id,
  ]
}

output "security_group_id" {
  description = "ID do grupo de segurança para a instância EC2"
  value       = aws_security_group.allow_http.id  
}

output "route_table_id" {
  description = "ID da tabela de roteamento externa"
  value       = aws_route_table.external_route_table.id  
}