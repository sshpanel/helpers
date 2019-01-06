#!/bin/bash

. $HOME/helpers/support/app-check.sh
. $HOME/helpers/support/os-detector.sh
. $HOME/helpers/support/string-helper.sh
. $HOME/helpers/support/welcome-screen.sh

cd ~

# make sure git is installed
apt-get install git -y

# installing composer
php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');"
php -r "if (hash_file('sha384', 'composer-setup.php') === '93b54496392c062774670ac18b134c3b3a95e5a5e5c8f1a9f115f203b75bf9a129d5daa8ba6a13e2cc8a1da0806388a8') { echo 'Installer verified'; } else { echo 'Installer corrupt'; unlink('composer-setup.php'); } echo PHP_EOL;"
php composer-setup.php
php -r "unlink('composer-setup.php');"
mv composer.phar /usr/local/bin/composer

# clone & install the agent
git clone https://github.com/sshpanel/v-agent.git
cd v-agent
composer install -vvv

# add agent executable insto .bashrc
echo "alias vpnpanel=\"php ~/v-agent/vpnpanel\"" >> ~/.bashrc
source ~/.bashrc 

# set the url & token
touch ~/v-agent/.env
echo "PANEL_URL=$PANEL_URL" >> ~/v-agent/.env
echo "PANEL_TOKEN=$PANEL_TOKEN" >> ~/v-agent/.env


# CLONING B-AGENT
cd /etc/openvpn
git clone https://github.com/sshpanel/b-agent agent
cd agent 
chmod -R 0755 *
