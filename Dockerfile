FROM tomcat:11.0.5-jdk21

# Instala dependências
RUN apt-get update && apt-get install -y unzip wget && rm -rf /var/lib/apt/lists/*

# Cria diretório temporário
WORKDIR /tmp

# Baixa o JasperReports Server Community Edition
RUN wget -O jrs.zip https://sourceforge.net/projects/jr-community-installers/files/Server/TIB_js-jrs-cp_8.2.0_bin.zip/download

# Extrai o zip
RUN unzip jrs.zip && \
    cp -r TIB_js-jrs-cp_8.2.0_bin/jasperreports-server-cp-8.2.0-bin/buildomatic/sample-application-jdbc/webapps/jasperserver.war /usr/local/tomcat/webapps/ && \
    rm -rf /tmp/*

# Copia config de usuários do Tomcat
COPY tomcat-users.xml /usr/local/tomcat/conf/

EXPOSE 8080
