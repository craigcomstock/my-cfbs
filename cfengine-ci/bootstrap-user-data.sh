#!/bin/bash

export HOME=/root
cd || exit

apt-get -qy update
apt-get -qy install git

git clone https://github.com/mendersoftware/mender-qa

sudo sed -i '/PermitRootLogin/d;$a PermitRootLogin without-password' /etc/ssh/sshd_config
sudo service ssh restart
if sudo test -e /root/.ssh; then
  sudo sed -i 's/.*ssh-rsa/ssh-rsa/' /root/.ssh/authorized_keys
else
  sudo cp -ar .ssh /root/
  sudo chown -R root:root /root/.ssh
fi

# I'm not sure how initialize-user-data.sh worked without this before ~aleksei, Sept 2022
touch /root/jenkins_buildslaves.id_rsa

# shellcheck disable=SC1091
. mender-qa/scripts/initialize-user-data.sh
