# Base image
FROM ubuntu:22.04

# Variáveis de ambiente
ENV DEBIAN_FRONTEND=noninteractive \
    TZ=America/Sao_Paulo \
    CATALINA_HOME=/opt/tomcat \
    CATALINA_BASE=/opt/tomcat \
    JAVA_HOME=/usr/lib/jvm/default-java \
    CATALINA_OPTS="-Xms1024M -Xmx2048M -server -XX:+UseParallelGC" \
    JASPER_VERSION=8.2.0

# Instalação de dependências
RUN apt-get update && apt-get install -y \
    default-jdk \
    wget \
    curl \
    unzip \
    gettext-base \
    && rm -rf /var/lib/apt/lists/*

# Configuração do Tomcat
RUN groupadd -r tomcat && \
    useradd -r -s /bin/false -g tomcat -d $CATALINA_HOME tomcat && \
    mkdir -p $CATALINA_HOME/{webapps,temp,logs,conf}

# Download e instalação do Tomcat 9.0.102
RUN wget -q https://archive.apache.org/dist/tomcat/tomcat-9/v9.0.102/bin/apache-tomcat-9.0.102.tar.gz -P /tmp && \
    tar -xzf /tmp/apache-tomcat-9.0.102.tar.gz -C $CATALINA_HOME --strip-components=1 && \
    rm /tmp/apache-tomcat-9.0.102.tar.gz

# Download do JasperReports
RUN wget -q https://sourceforge.net/projects/jr-community-installers/files/Server/TIB_js-jrs-cp_${JASPER_VERSION}_bin.zip -O /tmp/jasper.zip && \
    unzip /tmp/jasper.zip -d /tmp && \
    mv /tmp/jasperreports-server-cp-${JASPER_VERSION}-bin /tmp/jasper && \
    rm /tmp/jasper.zip

# Configuração da instalação
WORKDIR /tmp/jasper/buildomatic
COPY default_master.properties .

# Instalação
RUN ./js-install-ce.sh || \
    (echo "Fallback: Deploy manual" && \
     cp /tmp/jasper/jasperserver.war $CATALINA_HOME/webapps/ && \
     unzip $CATALINA_HOME/webapps/jasperserver.war -d $CATALINA_HOME/webapps/jasperserver/)

# Configurações finais
RUN chown -R tomcat:tomcat $CATALINA_HOME && \
    chmod -R 755 $CATALINA_HOME && \
    chmod +x $CATALINA_HOME/bin/*.sh

# Healthcheck
# Instale curl para healthcheck
RUN apt-get update && apt-get install -y curl && rm -rf /var/lib/apt/lists/*

# Healthcheck específico para JasperServer
HEALTHCHECK --interval=30s --timeout=10s --start-period=5m \
  CMD curl -f http://localhost:8080/jasperserver/login.html || exit 1

EXPOSE 8080

# Correção crítica - use caminho absoluto
USER tomcat
WORKDIR $CATALINA_HOME
CMD ["/opt/tomcat/bin/catalina.sh", "run"]
