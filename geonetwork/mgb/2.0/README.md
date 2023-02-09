# LEIAME - Perfil MGB 2.0 para o GeoNetwork 3.10

**Data e local:** Rio de Janeiro, 19 de maio de 2021

**Autor:** Raphael Brito / Instituto Brasileiro de Geografia e Estatística (IBGE)

**Contato:** dbdg@inde.gov.br

-----------------------------------------------------------------------

## Pré-requisitos/observações:

- Testado no GeoNetwork 3.10.2;
    
- O arquivo war deve ser descompactado para as alterações. Após, é recomendado que ele seja utilizado no servidor de aplicações como está, sem a necessidade de gerar novamente um war;

- Os arquivos fornecidos neste momento estão aptos a serem utilizados em ambiente de produção; isso não impede que versões melhoradas ou corrigidas sejam disponibilizadas em momento posterior;

## Instalação:

1) Copiar os dois diretórios `iso19115-3.2018` e `iso19115-3.mgb` para
`geonetwork/WEB-INF/data/config/schema_plugins/`, sobreescrevendo os arquivos já
existentes;

2) Copiar o arquivo `config-spring-mgb-2.xml` para `geonetwork/WEB-INF/`;
  
3) Editar o arquivo `geonetwork/WEB-INF/config-spring-geonetwork.xml`,
adicionando a seguinte linha na posição de **linha 49** do arquivo original (após os imports iniciais):

``` xml
<import resource="config-spring-mgb-2.xml"/>
```

4) Iniciar o servidor de aplicações;
  
5) Após o período de inicialização da aplicação, acessar seu endereço e
realizar login com a conta de administrador. Navegar para **"Console de Administrador"**, **"Metadados e Modelos"**. Marcar o perfil MGB 2.0 listado. Clicar em **"Carregar modelos para os padrões selecionados"**.