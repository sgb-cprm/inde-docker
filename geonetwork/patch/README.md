Rio de Janeiro, 23 de abril de 2021
LEIAME - Alterações do GeoNetwork 3.10.2
Autor: Raphael Brito / Instituto Brasileiro de Geografia e Estatística (IBGE)
Contato: dbdg@inde.gov.br

  --> Pré-requisitos/observações:

    - As alterações fornecidas neste pacote são específicas para a versão 3.10.2
  do GeoNetwork. A sua aplicação em qualquer outra versão do projeto só pode ser
  feita mediante análise manual do código a ser substituído;

    - As alterações fornecidas são apenas correções e não contemplam os perfis
  MGB, customizações ou configurações do projeto para início de operação.
  Consultar documentos próprios para esses procedimentos;

    - As principais correções fornecidas dizem respeito à tradução e ao
  procedimento de migração da base de dados de versões antigas do GeoNetwork.
  Consultar o arquivo historico-de-alteracoes.txt para maiores detalhes;

    - Uma alteração feita em arquivo binário (.jar) é fornecida pronta para uso
  (compilada). Em cumprimento à licença de código fonte do projeto, o arquivo de
  código fonte alterado é fornecido em paralelo;

    - O arquivo war deve ser descompactado para as alterações. Após, é
  recomendado que ele seja utilizado no servidor de aplicações como está, sem a
  necessidade de gerar novamente um war;

    - Os arquivos fornecidos neste momento estão aptos a serem utilizados em
  ambiente de produção; isso não impede que versões melhoradas ou corrigidas
  sejam disponibilizadas em momento posterior;
  
  --> Instalação:

  1) Copiar o diretório geonetwork fornecido sobre o diretório do war já
descompactado, sobreescrevendo todas as correspondências;
