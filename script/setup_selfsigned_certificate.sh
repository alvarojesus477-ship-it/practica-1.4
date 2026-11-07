#!/bin/bash
set -x
# Importamos las variables de entorno
source .env

# Creamos el certificado autofirmado
sudo openssl req \
  -x509 \
  -nodes \
  -days 365 \
  -newkey rsa:4096 \
  -keyout /etc/ssl/private/apache-selfsigned.key \
  -out /etc/ssl/certs/apache-selfsigned.crt \
  -subj "/C=$OPENSSL_COUNTRY/ST=$OPENSSL_PROVINCE/L=$OPENSSL_LOCALITY/O=$OPENSSL_ORGANIZATION/OU=$OPENSSL_ORGUNIT/CN=$OPENSSL_COMMON_NAME/emailAddress=$OPENSSL_EMAIL"

# Copiamos los archivos de configuracion de Apache 
cp ../conf/default-ssl.conf  /etc/apache2/sites-available/default-ssl.conf
cp ../conf/000-default.conf /etc/apache2/sites-available/000-default.conf

# Habilitamos el virtual host de apache para ssl
sudo a2ensite default-ssl.conf

# Habilitamos el virtual host de apache para la redireccion a https
sudo a2ensite 000-default.conf

#Habilitamos el modulo de SSL en Apache
sudo a2enmod ssl

# Para que el servidor web Apache pueda hacer la redirección de HTTP a HTTPS es necesario habilitar el módulo rewrite en Apache
sudo a2enmod rewrite


# Reiniciamos Apache para aplicar los cambios
sudo systemctl restart apache2