# INDE Docker

![INDE - Infraestrutura Nacional de Dados Espaciais](https://inde.gov.br/img/INDE%20Logo_2.png "INDE")

Implementação de stack de serviços de container (docker) para suporte a [Infraestrutura de Nacional de Dados Espaciais (INDE)](https://www.inde.gov.br/).

O objetivo consiste em reproduzir, em arquitetura Docker, a instalação de um ambiente de gestão de metadados e geoserviços conforme as recomendações da [INDE](https://metadados.inde.gov.br/downloads/manual-instalacao-gn3.pdf).

> Esta composição é apenas para referência, testes e estudos. Não pode ser utilizado diretamente em produção sem nenhum tipo de ajuste de otimização e segurança.

A configuração descrita neste projeto utiliza imagens certificadas pelo [Docker](https://hub.docker.com/) e também imagens construídas por fontes confiáveis.

## Componentes do stack

### Proxy Reverso (Nginx)

A inclusão de um proxy reverso tem como objetivo a não exposição da porta dos serviços de aplicação (no caso do Geoserver e do Geonetwork, o Tomcat), além de permitir outras configurações de porta de entrada ao conjunto, como adição de certificados SSL.

> Para ajustar as configurações do Nginx, basta editar o arquivo **nginx.conf**

É possível, também, personalizar a página de entrada do stack, a partir de conteúdo estático em HTML

> Para personalizar a página de entrada do stack, basta acrescentar HTML em ```nginx/html```, com página incial nomeado **index.html**

### Serviço de Metadados (Geonetwork)

Esta é a unica imagem que recebeu algum tipo de extensão, via **Dockerfile**. Para isso, a imagem padrao recebeu os conteúdos produzidos pelo IBGE, seguindo as instruçoẽs do [Manual Básico de Instalação e Configuração do Geonetwork da INDE](https://metadados.inde.gov.br/downloads/manual-instalacao-gn3.pdf).

Para os que desejarem produzir os próprios builds da imagem, o "build arg" do **Dockerfile** precisa receber como valor o [nome da tag correspondente a versão do Geonetwork a ser utilizado](https://hub.docker.com/_/geonetwork?tab=tags).

``` bash
# Exemplo: Criação de uma imagem de geonetwork com usando a versão 3.10.6, com banco de dados H2 como backend
GEONETWORK_VERSION=3.10.6 && docker build --build-arg GEONETWORK_IMAGE_TAG=${GEONETWORK_VERSION} -t cprm/inde-geonetwork:${GEONETWORK_VERSION} geonetwork/
```

### Serviço de Mapas (Geoserver)

Junto do serviço de metadados, está disponível, para referência, uma instância de container de Geoserver, desenvolvido e mantido pela [Kartoza](https://kartoza.com/en/). 

As referências para configurações e ajustes estão disponíveis na [Página da Imagem](https://hub.docker.com/r/kartoza/geoserver)

### Banco de Dados Espacial (PostGIS)

Este stack possui como backend um banco de dados PostgreSQL, com PostGIS. Junto do mesmo, há um pequeno script para a criação dos dois bancos, a partir de variáveis de ambiente definidas

Para execução em modo de testes e avaliação, o banco de dados em container é suficiente para a operação dos dois serviços de aplicação.

Caso seja necessário conectar os containers em máquina física/virtual, é necessário criar os bancos, extensões e users, e passar as credenciais via variáveis de ambiente.

> Nota: O uso de variáveis de ambiente para definição de configurações sensíveis (senhas) é desencorajado, por razṍes de segurança.

## Variáveis de Ambiente Globais (.env)

O arquivo ```.env``` contém as variáveis de ambiente necessárias para modificar o comportamento do ```docker-compose``` para definir corretamente os caminhos de arquivos e bancos de dados para o Geoserver e o Geonetwork.

### Banco de Dados PostgreSQL/PostGIS

- **POSTGRES_HOST:** db
- **POSTGRES_PORT:** 5432
- **POSTGRES_DATA_DIR:** /var/lib/postgresql/data

Para executar o stack sem o banco de dados em container, é necessário criar dois bancos de dados

### Geonetwork

- **GEONETWORK_VERSION:** Tag referente a versão utilizada do Geonetwork (padrão ```3.10.2```)
- **GEONETWORK_DATA_DIR:** Diretório de dados do geonetwork dentro do container (padrão ```/srv/geonetwork/data```)

Credenciais de banco de dados do Geonetwork

- **GEONETWORK_DATABASE:** geonetwork
- **GEONETWORK_USER:** geonetwork
- **GEONETWORK_PASSWORD:** geonetwork@INDE

### GeoServer

- **GEOSERVER_VERSION:** Tag referente a versão utilizada do Geoserver (padrão ```2.20.2```)
- **GEOSERVER_DATA_DIR:** Diretório de dados do geonetwork dentro do container (padrão ```/srv/geoserver/data```)

As credenciais de banco de dados do Geoserver referem-se, inicialmente, aos controles de cota de disco de cache, conforme [documentação da imagem](https://hub.docker.com/r/kartoza/geoserver).

- **GEOSERVER_DATABASE:** geoserver
- **GEOSERVER_USER:** geoserver
- **GEOSERVER_PASSWORD:** geoserver@INDE

## Construção da imagem em docker local

```bash
source .env && docker-compose -f docker-compose.yml -f docker-compose.build.yml up --build
```

## Execução do stack (com download da imagem)

```bash
source .env && docker-compose up
```

## Referências

- [Manual Básico de Instalação e Configuração](https://metadados.inde.gov.br/downloads/manual-instalacao-gn3.pdf) do Geonetwork da INDE
- Imagem Docker Oficial de [Nginx](https://registry.hub.docker.com/_/nginx)
- Imagem Docker Oficial de [Geonetwork](https://hub.docker.com/_/geonetwork)
- Imagem Docker de [Geoserver](https://hub.docker.com/r/kartoza/geoserver), desenvolvido por [Kartoza](https://kartoza.com/en/)
- Imagem de [PostGIS](https://hub.docker.com/r/postgis/postgis) dos [desenvolvedores](http://postgis.net/) da extensão
- Imagem Docker Oficial de [PostgreSQL](https://registry.hub.docker.com/_/postgres)
