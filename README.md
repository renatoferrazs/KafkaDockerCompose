# KafkaDockerCompose
Script para criar instalar Docker com Kafka e interface Kafka-UI para Linux ou WSL2

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
* Instalação o Docker e Docker Compose.
* Configura permissões para rodar o Docker sem sudo.
* Cria o arquivo docker-compose.yml automaticamente com as configurações do Kafka, Zookeeper e Kafka UI.
* Instalação de ferramentas como curl e gnupg são necessárias para baixar e verificar a chave GPG do Docker.
* Chave GPG do Docker para garantir que os pacotes Docker sejam confiáveis.
* Adiciona o repositório do Docker oficial para garantir que a instalação pegue os pacotes diretamente da fonte.

O serviço kafka-ui que está incluído no arquivo é uma interface gráfica que permite visualizar e gerenciar os tópicos e mensagens do Kafka.

# Após executar o script
Acessar o Kafka-UI no endereço http://localhost:8080, onde poderá monitorar e interagir com seu cluster Kafka.




# Comandos básicos do Docker Compose listados em tópicos sequenciais:

Subir os serviços (containers):	```docker-compose up```

Em segundo plano: ```docker-compose up -d```

Parar os serviços:	```docker-compose stop```

Derrubar os serviços (remover containers):	```docker-compose down```


Para remover volumes: ```docker-compose down -v```

Listar os containers em execução:	```docker-compose ps```

Ver logs dos containers:
* Todos os logs: ```docker-compose logs```
* Logs de um serviço específico: ```docker-compose logs nome_do_serviço```
* Logs em tempo real: ```docker-compose logs -f```
 

Reiniciar os serviços: 
* Todos os serviços: ```docker-compose restart```
* Serviço específico: ```docker-compose restart nome_do_serviço```

Ver informações detalhadas dos containers:	```docker-compose top```

Executar um comando em um container:	```docker-compose exec nome_do_serviço comando```

Exemplo (acessar o shell): ```docker-compose exec kafka bash```

Atualizar os containers (reconstruir):	```docker-compose up -d --build```
