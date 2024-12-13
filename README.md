# Desafio DevOps

Este projeto provisiona uma infraestrutura na AWS utilizando **Terraform** para criar uma instância EC2 com o sistema operacional Debian 12, além de configurar automaticamente o servidor Nginx na instância. A infraestrutura também inclui uma VPC, Subnet, Internet Gateway, Security Group e outras boas práticas de segurança.

## Conteúdo do Repositório

- `main.tf`: Arquivo principal que define a infraestrutura da AWS.
- `output.tf`: Contém as saídas da infraestrutura, incluindo chaves privadas e IPs públicos.
- `security-group.tf`: Define os grupos de segurança para permitir o tráfego de entrada e saída.
- `variables.tf`: Contém variáveis utilizadas no projeto.
- `ec2.tf`: contém a definição da instância EC2 e a automação necessária para provisionar o servidor web Nginx.

-obs.: A divisão do arquivo main.tf em vários arquivos melhora a organização e o entendimento do projeto. Essa abordagem segue as boas práticas, pois facilita a visualização e a manutenção de cada componente da infraestrutura de forma isolada, tornando o código mais modular e fácil de modificar ou expandir no futuro.

## Estrutura da Infraestrutura

A infraestrutura criada inclui os seguintes componentes:

- **main.tf**: Contém a configuração básica da VPC, Subnet, Internet Gateway, Security Group, e rotas.
- **ec2.tf**: Contém a configuração da instância EC2 (debian_ec2), incluindo a instalação do Nginx.
- **outputs.tf**: Define os outputs, como o IP público da instância EC2 e a chave privada para acesso via SSH.

## Objetivos

- Provisionar infraestrutura na AWS usando Terraform.
- Configurar automaticamente o Nginx na instância EC2.
- Implementar boas práticas de segurança (como restrição de acesso SSH e gerenciamento de Key Pairs).

## Modificações no main.tf
**Divisão do Código**
- O arquivo main.tf original foi dividido em dois arquivos: main.tf e ec2.tf.
- O ec2.tf contém apenas a definição da instância EC2, enquanto o main.tf mantém a configuração de rede (VPC, Subnet, Security Group, etc.).

**Instância EC2 Separada**
- O recurso aws_instance "debian_ec2" foi movido para o arquivo ec2.tf, onde foi configurado para utilizar a Key Pair gerada dinamicamente e realizar a instalação do Nginx.

**Instalação Automática do Nginx:**
- No arquivo ec2.tf, o bloco user_data foi modificado para instalar e iniciar o servidor Nginx automaticamente após a criação da instância.
  
```
user_data = <<-EOF
  #!/bin/bash
  echo "Update the server"
  echo "------------------------"
  sudo apt-get update
  sudo apt-get upgrade -y

  echo "Install Nginx"
  echo "------------------------"
  sudo apt-get install nginx -y
  
  echo "Starting Nginx"
  echo "------------------------"
  sudo systemctl start nginx
  
  echo "Enable Nginx to start on boot"
  echo "------------------------"
  sudo systemctl enable nginx
  EOF
```
-Obs.: o arquivo foi colocado dentro file chamado "script.sh" e o meu user_data ficou user_data = file("script.sh")

**Geração Dinâmica da Key Pair**
- A chave privada é gerada dinamicamente usando o recurso tls_private_key e associada à instância EC2 via o recurso aws_key_pair. Isso garante que a Key Pair seja gerada automaticamente e que você não precise subir uma chave privada manualmente.

**Outputs Sensíveis**
-A chave privada (private_key) e o endereço IP público (ec2_public_ip) são exibidos como outputs para facilitar o acesso à instância EC2 após a criação da infraestrutura.

## Como Usar

1. **Pré-requisitos**:
   - Ter o [Terraform](https://www.terraform.io/downloads.html) instalado.
   - Ter uma conta na [AWS](https://aws.amazon.com/) com as credenciais configuradas.
  
2. **Clonar o repositório**
    ```
    git clone https://github.com/Edugon0/Desafio_DevOps
    ```
   - Localize o diretório onde você clonou o repositório em sua máquina e execute o seguinte comando
    - EX:
     ```
     cd C:\Users\eduar\Documents\DevOps
     ```

3. **Inicializar o Terraform (será necessario para rastreará os arquivos de configuração)**:
   ```
     terraform init
    ```
5. **Verificar o plano de execução**
   ```
     terraform plan
   ```

7. **Aplicar a configuração:**
   ```
     terraform apply
   ```
    
3. **Destruir a infraestrutura (se necessário):**
   ```
     terraform destroy
   ```
4. Acesso à instância
  -Para acessar a instância, utilize a nova chave SSH:
   ```
   ssh -i /caminho/para/nova-chave.pem ubuntu@<IP-da-instância>
   ```
   

- Obs.: Certifique-se de que sua AWS está configurada na região us-east-1 ao rodar o projeto, pois essa é a região definida no código. Além disso, ao testar o servidor Nginx, lembre-se de acessar via HTTP (porta 80), uma vez que a configuração foi feita para permitir o tráfego HTTP, e não HTTPS.


## Melhorias Futuras

- Implementar monitoramento e logs de fluxo da VPC para maior visibilidade e controle de segurança.
- Escalar a solução utilizando um Load Balancer e várias instâncias EC2.
- Containerizar o Nginx utilizando Docker e integrar com Kubernetes (EKS) para gerenciar múltiplos containers.
