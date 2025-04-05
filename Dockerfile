FROM tomcat:11.0.5-jdk21

COPY tomcat-users.xml /usr/local/tomcat/conf/

# Opcional – sua aplicação .war na raiz
COPY ROOT.war /usr/local/tomcat/webapps/

EXPOSE 8080
