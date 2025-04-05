FROM tomcat:9.0-jdk17

ENV JRS_VERSION=8.2.0 \
    JRS_DIR=/opt/jasperserver \
    CATALINA_HOME=/usr/local/tomcat

WORKDIR /opt

# Instala dependências
RUN apt update && apt install -y unzip wget default-jdk nano && rm -rf /var/lib/apt/lists/*

RUN wget https://sourceforge.net/projects/jr-community-installers/files/Server/TIB_js-jrs-cp_${JRS_VERSION}_bin.zip/download -O jrs.zip && \
    unzip jrs.zip && \
    mv $(find . -type d -name "jasperreports-server-cp-${JRS_VERSION}-bin") $JRS_DIR && \
    rm jrs.zip


# Copia a config e instala o JasperReports
RUN cd $JRS_DIR/jasperreports-server-cp-${JRS_VERSION}-bin/buildomatic && \
    ./js-install-ce.sh

EXPOSE 8080

CMD ["catalina.sh", "run"]
