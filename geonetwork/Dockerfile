# Argumento padrão em cima da versão que usa HSQL, para testes
ARG GEONETWORK_IMAGE_TAG=3.10.2

# The BUILDER stage is to get zipfiles from INDE portal and corrct some files before geonetwork config
FROM geonetwork:${GEONETWORK_IMAGE_TAG}

ARG MGB2_DOWNLOAD_URL=https://metadados.inde.gov.br/downloads/perfil-mgb2-20220216.zip
ARG MGB_LEGACY_DOWNLOAD_URL=https://metadados.inde.gov.br/downloads/perfis-mgb-20220216.zip
ARG GEONETWORK_MODS_DOWNLOAD_URL=https://metadados.inde.gov.br/downloads/alteracoes-geonetwork-20210423.zip

WORKDIR /tmp

# Ajustar locale para pt_BR
RUN apt-get -y update && \
    apt-get -y install locales wget && \    
    sed -i '/pt_BR.UTF-8/s/^# //g' /etc/locale.gen && \
    locale-gen && \
    apt-get -y autoremove --purge && \
    rm -rf /var/lib/apt/lists/*

ENV LC_ALL=pt_BR.UTF-8 \
    LANG=pt_BR.UTF-8 \
    LANGUAGE=pt_BR:pt

# Arquivos para o geonetwork reconhecer os perfis INDE
ENV MGB_CONFIG_FILE=config-spring-mgb.xml \
    MGB2_CONFIG_FILE=config-spring-mgb-2.xml

# Customizações do DBDG/INDE
RUN tmpfile=inde-mods.zip && \
    wget -qO ${tmpfile} ${GEONETWORK_MODS_DOWNLOAD_URL} && \
    unzip -qo ${tmpfile} -d ${CATALINA_HOME}/webapps && returncode=$? || returncode=$? && \
    if [ returncode -gt 1 ]; then exit returncode; fi && \
    rm -rf ${tmpfile}

# Perfil completo MGB 2.0
RUN tmpfile=mgb2.zip && \
    wget -qO ${tmpfile} ${MGB2_DOWNLOAD_URL} && \
    unzip -qo ${tmpfile} && returncode=$? || returncode=$? && \
    if [ $returncode -gt 1 ]; then exit $returncode; fi && \
    cp -rp mgb2/* ${DATA_DIR}/config/schema_plugins && \
    rm -rf ${tmpfile} mgb2/ && \
    mv ${DATA_DIR}/config/schema_plugins/${MGB2_CONFIG_FILE} \
        ${CATALINA_HOME}/webapps/geonetwork/WEB-INF

# Perfil legado MGB (completo e simplificado)
RUN tmpfile=mgb.zip && \
    wget -qO ${tmpfile} ${MGB_LEGACY_DOWNLOAD_URL} && \
    unzip -qo ${tmpfile} && returncode=$? || returncode=$? && \
    if [ $returncode -gt 1 ]; then exit $returncode; fi && \
    cp -rp mgb/* ${DATA_DIR}/config/schema_plugins && \
    rm -rf ${tmpfile} mgb/&& \
    mv ${DATA_DIR}/config/schema_plugins/${MGB_CONFIG_FILE} \
        ${CATALINA_HOME}/webapps/geonetwork/WEB-INF

# Habilitar os perfis no geonetwork
RUN sed -i '49i <import resource="config-spring-mgb.xml"/>\n<import resource="config-spring-mgb-2.xml"/>' \
        ${CATALINA_HOME}/webapps/geonetwork/WEB-INF/config-spring-geonetwork.xml   

# Definições de JVM, de acordo com o manual da INDE
ENV CATALINA_OPS="-Xms2048m -Xmx2048m -XX:NewRatio=2 -XX:SurvivorRatio=10"

WORKDIR ${CATALINA_HOME}