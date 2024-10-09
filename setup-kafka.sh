#!/bin/bash

# Atualiza a lista de pacotes
echo "Atualizando lista de pacotes..."
sudo apt-get update -qq

# Instala pré-requisitos
echo "Instalando pré-requisitos..."
sudo apt-get install -y -qq ca-certificates curl gnupg lsb-release

# Adiciona a chave GPG oficial do Docker
echo "Adicionando chave GPG do Docker..."
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg

# Adiciona o repositório do Docker
echo "Adicionando repositório Docker..."
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu \
  $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

# Atualiza a lista de pacotes novamente após adicionar o repositório Docker
sudo apt-get update -qq

# Instala Docker e Docker Compose
echo "Instalando Docker e Docker Compose..."
sudo apt-get install -y -qq docker-ce docker-ce-cli containerd.io docker-compose

# Adiciona o usuário ao grupo Docker para evitar necessidade de sudo
echo "Configurando permissões para o Docker..."
sudo usermod -aG docker $USER

echo "Para aplicar as mudanças, faça logout e login novamente."


cat <<EOF > docker-compose.yml

services:
  kafka:
    image: bitnami/kafka:latest
    ports:
      - "9092:9092"
      - "9093:9093"
    environment:
      KAFKA_ADVERTISED_LISTENERS: INSIDE://kafka:9092,OUTSIDE://localhost:9093
      KAFKA_LISTENER_SECURITY_PROTOCOL_MAP: INSIDE:PLAINTEXT,OUTSIDE:PLAINTEXT
      KAFKA_LISTENERS: INSIDE://0.0.0.0:9092,OUTSIDE://0.0.0.0:9093
      KAFKA_ZOOKEEPER_HOSTS: zookeeper:2181
      KAFKA_INTER_BROKER_LISTENER_NAME: INSIDE
    depends_on:
      - zookeeper
      
  zookeeper:
    image: bitnami/zookeeper:latest
    ports:
      - 2181:2181
    environment:
      - ALLOW_ANONYMOUS_LOGIN=yes

  kafka-ui:
    image: provectuslabs/kafka-ui:latest
    ports:
      - "8080:8080"
    environment:
      KAFKA_CLUSTERS_0_NAME: local
      KAFKA_CLUSTERS_0_BOOTSTRAPSERVERS: kafka:9092
      KAFKA_CLUSTERS_0_ZOOKEEPER: zookeeper:2181
      KAFKA_CLUSTERS_0_PROPERTIES_SECURITY_PROTOCOL: PLAINTEXT
      
      # Configuração do segundo cluster caso tenha
      # KAFKA_CLUSTERS_1_NAME: segundo-cluster
      # KAFKA_CLUSTERS_1_BOOTSTRAPSERVERS: <ip-do-segundo-cluster>:9092
      # KAFKA_CLUSTERS_1_ZOOKEEPER: <ip-do-segundo-cluster>:2181
      # KAFKA_CLUSTERS_1_PROPERTIES_SECURITY_PROTOCOL: PLAINTEXT
    depends_on:
      - kafka

EOF

# Inicia os containers usando Docker Compose
echo "Rodando Docker Compose..."
if ! docker-compose up -d; then
    echo "Erro ao iniciar os containers. Verifique os logs para mais detalhes."
fi

echo "Instalação e execução concluídas! Acesse o Kafka UI via http://localhost:8080"
