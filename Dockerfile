FROM tomcat:9.0-jdk17

# Variáveis
ENV JRS_VERSION=8.2.0 \
    JRS_DIR=/opt/jasperserver \
    CATALINA_HOME=/usr/local/tomcat

# Instalar dependências
RUN apt update && apt install -y \
    unzip \
    wget \
    default-jdk \
    nano \
    gnupg \
    && rm -rf /var/lib/apt/lists/*

# Criar diretório de trabalho
WORKDIR /opt

# Baixar e extrair JasperReports
RUN wget https://sourceforge.net/projects/jr-community-installers/files/Server/TIB_js-jrs-cp_${JRS_VERSION}_bin.zip/download -O jrs.zip && \
    unzip jrs.zip && \
    mv TIB_js-jrs-cp_${JRS_VERSION}_bin $JRS_DIR && \
    rm jrs.zip

# Copiar o arquivo de config do banco
COPY default_master.properties $JRS_DIR/jasperreports-server-cp-${JRS_VERSION}-bin/buildomatic/default_master.properties

# Rodar instalação
RUN cd $JRS_DIR/jasperreports-server-cp-${JRS_VERSION}-bin/buildomatic && \
    ./js-install-ce.sh

# Expor porta
EXPOSE 8080

# Iniciar o Tomcat
CMD ["catalina.sh", "run"]
