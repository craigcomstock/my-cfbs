#!/bin/bash

export HOME=/root
cd || exit

apt-get -qy update
apt-get -qy install git

git clone https://github.com/mendersoftware/mender-qa

# TODO need sftp cache key

#sed -i 's/.*ssh-rsa/ssh-rsa/' /root/.ssh/authorized_keys

# shellcheck disable=SC1009
# shellcheck disable=SC1091
. mender-qa/scripts/initialize-user-data.sh
