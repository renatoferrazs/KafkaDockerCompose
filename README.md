# KafkaDockerCompose
Script para criar instalar Docker com Kafka e itnerface Kafka-UI para Linux ou WSL2

# Dê permissão de execução

No terminal, navegue até o diretório onde o script está salvo e execute o seguinte comando:

```
chmod +x setup-kafka.sh
```
Antes de executar o script, valide a linha 44 do arquivo e altere os dados de localhost, colocando o ip da maquina:

```
KAFKA_ADVERTISED_LISTENERS: INSIDE://kafka:9092,OUTSIDE://localhost:9093
```

Execute o script 

```
./setup-kafka.sh
```

Script completo que inclui:

* Atualiza os pacotes e instala pré-requisitos.
* Instala o Docker e Docker Compose.
* Configura permissões para rodar o Docker sem sudo.
* Cria o arquivo docker-compose.yml automaticamente com as configurações do Kafka, Zookeeper e Kafka UI.

O serviço kafka-ui está incluído no arquivo docker-compose.yml que o script cria. O Kafka-UI é uma interface gráfica que permite visualizar e gerenciar os tópicos e mensagens do Kafka.


  Já esta incluso no Script:
* Instalação de ferramentas como curl e gnupg são necessárias para baixar e verificar a chave GPG do Docker.
* Chave GPG do Docker para garantir que os pacotes Docker sejam confiáveis.
* Adiciona o repositório do Docker oficial para garantir que a instalação pegue os pacotes diretamente da fonte.

# Após executar o script
Em http://localhost:8080, interface do Kafka-UI onde poderá monitorar e interagir com seu cluster Kafka.
