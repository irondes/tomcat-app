FROM tomcat:9-jdk11

ENV JRS_VERSION=8.2.0
ENV JRS_DIR=/opt/jasperserver

RUN apt-get update && apt-get install -y unzip wget fontconfig \
    && wget https://sourceforge.net/projects/jr-community-installers/files/Server/TIB_js-jrs-cp_${JRS_VERSION}_bin.zip/download -O jrs.zip \
    && unzip jrs.zip \
    && mv jasperreports-server-cp-${JRS_VERSION}-bin ${JRS_DIR} \
    && rm jrs.zip

WORKDIR ${JRS_DIR}/buildomatic

COPY default_master.properties ${JRS_DIR}/buildomatic/default_master.properties

RUN ./js-install-ce.sh
