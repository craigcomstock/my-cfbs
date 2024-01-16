#!/bin/bash

set -x

# shellcheck disable=SC1091
. mender-qa/scripts/initialize-build-host.sh

# Add 512MB swap space, java needs it, and jenkins stops complaining.
sudo mender-qa/scripts/create_swap_file.sh 512

# install Java
# echo "deb http://mirrors.digitalocean.com/debian jessie-backports main" | sudo tee --append /etc/apt/sources.list.d/jessie-backports.list &gt; /dev/null
# sudo apt-get -qy -q update
# sudo apt-get -qy install -t jessie-backports openjdk-8-jdk
sudo apt-get -qy install openjdk-8-jdk

sudo apt-get -qy  install git autoconf automake m4 make bison flex binutils libtool gcc g++ libc-dev libpam0g-dev python liblmdb-dev libssl-dev libpcre3-dev psmisc

# For GitHub API calls
sudo apt-get -qy install curl jq

# copied from https://gitlab.com/Northern.tech/CFEngine/jenkins-vms/-/blob/master/machines/debian-9-x64-bootstrap/Vagrantfile
sudo apt-get -qy install php php-gd php-mbstring php-xml php-ldap unzip pigz parallel

curl -sL https://deb.nodesource.com/setup_12.x | sudo bash -
sudo apt-get -y install nodejs
php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');"
sudo php composer-setup.php --install-dir=/usr/bin
php -r "unlink('composer-setup.php');"

sudo -u jenkins ssh -o StrictHostKeyChecking=no git@github.com || true
