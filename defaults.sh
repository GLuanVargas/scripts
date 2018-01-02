#!/bin/sh

##########################
# Script feito para criar uma VM voltada a desenvolvimento em php.
#
# Pre-requisitos
#
# 1 - CD dos Adicionais inserido
# 2 - Pasta que ira compartilhar com a /var/www/html montada no VirtualBox em "Configuracoes>Pastas Compartilhadas"
#                
##########################

### Modulos PHP instalados  ###

#libapache2-mod-php7.1 - Biblioteca para modulos
#php7.1                - Instalar PHP
#php7.1-cli            - Command line interpreter
#php7.1-common         - documentation, examples and common module for PHP
#php7.1-curl           - cURL module for PHP (trabalhar com URLs)
#php7.1-dev            - Arquivos para desenvolvimento
#php7.1-gd             - Criar imagens com PHP
#php7.1-mcrypt         - libmcrypt module for PHP
#php7.1-mysql          - Mysql arquivos
#php7.1-pdo            - PDO arquivos
#php7.1-json           - Arquivos JSON

### phpMyAdmin requer ###

#php7.1-gettext
#php7.1-mbstring

#Variaveis
DIR=/opt/VBoxGuestAdditions*

# Cores

SemCor='\033[0m'               # Volta ao normal texto
Vermelho='\033[0;31m'          # Vermelho
Verde='\033[0;32m'             # Verde
Amarelo='\033[0;33m'           # Amarelo
Roxo='\033[0;35m'              # Roxo
AzulClaro='\033[0;36m'         # Azul claro

echo "$AzulClaro \n Atualizando pacotes... $SemCor" 
sudo apt-get update -y && sudo apt-get upgrade -y

echo "$AzulClaro \n Baixando pacotes necessarios para funcionamento... $SemCor" 
sudo apt-get install -y dkms build-essential linux-headers-generic linux-headers-$(uname -r) virtualbox-guest-utils virtualbox-guest-x11 virtualbox-guest-dkms

if [ ! -d $DIR ]; then
        echo "$AzulClaro \n Montando CD convidados virtualbox...  $SemCor" 
        sudo mount /dev/cdrom /media/cdrom

        echo "$AzulClaro \n Instalando CD convidados virtualbox...  $SemCor" 
        sudo /media/cdrom/VBoxLinuxAdditions.run
fi

echo "$AzulClaro \n Instalando Apache2 e modulos necessarios...  $SemCor" 
sudo apt-get install -y apache2 apache2-utils

echo "$AzulClaro \n Instalando PHP e modulos necessarios...  $SemCor" 
sudo apt-get install -y libapache2-mod-php7.1 php7.1 php7.1-cli php7.1-common php7.1-curl php7.1-dev php7.1-gd php7.1-mcrypt php7.1-mysql php7.1-pdo php7.1-json php7.1-gettext php7.1-mbstring

echo "$AzulClaro \n Instalando MYSQL...  $SemCor" 
sudo apt-get install -y mysql-server

echo "$AzulClaro \n Instalando phpMyAdmin...  $SemCor" 
sudo apt-get install -y phpmyadmin

#Efetuando configuracao do MYSQL
echo -e "$AzulClaro \n Configurando MYSQL... $SemCor"
sudo mysql_secure_installation


# Enabling Mod Rewrite, required for WordPress permalinks and .htaccess files
echo -e "$AzulClaro \n Habilitando modulos PHP... $SemCor"
sudo phpenmod mcrypt
sudo phpenmod mbstring

# Restart Apache
echo -e "$AzulClaro \n Reiniciando apache $SemCor"
sudo service apache2 restart

echo -e "$AzulClaro \n Preparando para montar diretorios $SemCor"
sudo ln -sf /opt/VBoxGuestAdditions*/other/mount.vboxsf /sbin/mount.vboxsf

echo -e "$AzulClaro \n Executar seguinte comando: \n mount -t vboxsf -o uid=$UID,gid=$(id -g) {PastaMontadaMaquinaPrincipal} {DiretorioMaquinaVirtual} $SemCor"

