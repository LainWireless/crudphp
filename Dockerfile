FROM debian:bullseye
LABEL Iván Piña Castillo "ivanpicas88@gmail.com"
RUN apt update && apt upgrade -y && apt install apache2 libapache2-mod-php php php-mysql mariadb-client -y && apt clean && rm -rf /var/lib/apt/lists/*
ADD src /var/www/html/
ENV DB_HOST bd_mariadb_crudphp
ENV DB_NAME crudphp
ENV DB_USER admin
ENV DB_PASSWORD admin
ADD script.sh /opt/
RUN chmod +x /opt/script.sh && rm /var/www/html/index.html
ENTRYPOINT ["/opt/script.sh"]