#!/bin/bash

# Configuramos el script para que se muestren los comandos
# y finalice cuando hay un error en la ejecución
set -ex

# Actualiza la lista de paquetes
apt update

# Actualizamos los paquetes del sistema operativo
apt upgrade -y

# Instalamos el servidor web Apache
apt install apache2 -y

# Copiamos nuestro archivo de configuración de VirtualHost
cp ../conf/000-default.conf /etc/apache2/sites-available

# Instalamos los paquetes necesarios para tener PHP
apt install php libapache2-mod-php php-mysql -y

# Habilitamos el módulo rewrite de Apache
a2enmod rewrite

# Reiniciamos el servicio de Apache
systemctl restart apache2

# Copiar el archivo php/index.php a /var/www/html
cp ../php/index.php /var/www/html

# Modificamos el propietario del diretoro /var/www/html
chown -R www-data:www-data /var/www/html

# Instalamos MySQL Server
apt install mysql-server -y