#!/bin/bash

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

# Atualiza a lista de pacotes novamente
sudo apt-get update

# Instala Docker e Docker Compose
echo "Instalando Docker e Docker Compose..."
sudo apt-get install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

# Verifica se a instalação foi bem-sucedida
docker --version
docker compose version

# Inicia e habilita o serviço Docker
echo "Iniciando e habilitando o Docker..."
sudo systemctl start docker
sudo systemctl enable docker

# Permite que o usuário atual use o Docker sem sudo
echo "Configurando permissões para o Docker..."
sudo usermod -aG docker $USER

# Cria o arquivo docker-compose.yml com as configurações do Kafka e Kafka UI
echo "Criando arquivo docker-compose.yml..."

cat <<EOF > docker-compose.yml
services:
  zookeeper:
    image: wurstmeister/zookeeper:3.4.6
    ports:
      - "2181:2181"

  kafka:
    image: wurstmeister/kafka:latest
    ports:
      - "9092:9092"
      - "9093:9093"
    environment:
      KAFKA_ADVERTISED_LISTENERS: INSIDE://kafka:9092,OUTSIDE://<host-ip>:9093
      KAFKA_LISTENER_SECURITY_PROTOCOL_MAP: INSIDE:PLAINTEXT,OUTSIDE:PLAINTEXT
      KAFKA_LISTENERS: INSIDE://0.0.0.0:9092,OUTSIDE://0.0.0.0:9093
      KAFKA_ZOOKEEPER_CONNECT: zookeeper:2181
      KAFKA_INTER_BROKER_LISTENER_NAME: INSIDE
    depends_on:
      - zookeeper

  kafka-ui:
    image: provectuslabs/kafka-ui:latest
    ports:
      - "8080:8080"
    environment:
      KAFKA_CLUSTERS_0_NAME: local
      KAFKA_CLUSTERS_0_BOOTSTRAPSERVERS: kafka:9092
      KAFKA_CLUSTERS_0_ZOOKEEPER: zookeeper:2181
      KAFKA_CLUSTERS_0_PROPERTIES_SECURITY_PROTOCOL: PLAINTEXT
      
      # Configuração do segundo cluster
      # KAFKA_CLUSTERS_1_NAME: segundo-cluster
      # KAFKA_CLUSTERS_1_BOOTSTRAPSERVERS: <ip-do-segundo-cluster>:9092
      # KAFKA_CLUSTERS_1_ZOOKEEPER: <ip-do-segundo-cluster>:2181
      # KAFKA_CLUSTERS_1_PROPERTIES_SECURITY_PROTOCOL: PLAINTEXT
    depends_on:
      - kafka
EOF


# Subindo os containers com Docker Compose
echo "Rodando Docker Compose..."
docker compose up -d

echo "Instalação e execução concluídas! Acesse o Kafka UI via http://localhost:8080"
