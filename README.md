# KafkaDockerCompose
Script para criar instalar Docker com Kafka e itnerface Kafka-UI para Linux ou WSL2


Script completo que inclui:

* Instalação do Docker
* Docker Compose
* Arquivo docker-compose.yml com as configurações necessarias


# Certifica-se de que o sistema tenha informações atualizadas sobre os pacotes disponíveis.
  Já esta incluso no Script:
* Instalação de ferramentas como curl e gnupg são necessárias para baixar e verificar a chave GPG do Docker.
* Chave GPG do Docker para garantir que os pacotes Docker sejam confiáveis.
* Adiciona o repositório do Docker oficial para garantir que a instalação pegue os pacotes diretamente da fonte.


# Se o Docker já está instalado:
Se o Docker já está instalado e funcionando corretamente, você não precisa desse trecho. Ele é útil apenas para preparar o ambiente e instalar o Docker caso ele ainda não esteja disponível no sistema.

```
# Atualiza a lista de pacotes
echo "Atualizando lista de pacotes..."
sudo apt-get update

# Instala pré-requisitos
echo "Instalando pré-requisitos..."
sudo apt-get install -y ca-certificates curl gnupg lsb-release

# Adiciona a chave GPG oficial do Docker
echo "Adicionando chave GPG do Docker..."
sudo mkdir -m 0755 -p /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo tee /etc/apt/keyrings/docker.gpg > /dev/null

# Adiciona o repositório do Docker
echo "Adicionando repositório Docker..."
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \
  $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

```
