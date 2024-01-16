#!/bin/bash

# shellcheck disable=SC1091
. mender-qa/scripts/initialize-build-host.sh

# Add 512MB swap space, java needs it, and jenkins stops complaining.
sudo mender-qa/scripts/create_swap_file.sh 512

# use DEBIAN_FRONTEND=noninteractive to avoid prompts about service restarts
sudo env DEBIAN_FRONTEND=noninteractive apt-get -qy update
sudo env DEBIAN_FRONTEND=noninteractive apt-get -qy install bison flex binutils build-essential fakeroot ntp dpkg-dev libpam0g-dev debhelper pkg-config default-jre-headless psmisc libmodule-load-conditional-perl expat libexpat1-dev python3-psycopg2 gdb libncurses5

# install python2 and psycopg2
# python2-dev and libpq-dev are required on arm64 I think because no binaries exist in pip for psycopg2
sudo env DEBIAN_FRONTEND=noninteractive apt-get -qq install python2 libpq-dev python2-dev
wget https://bootstrap.pypa.io/pip/2.7/get-pip.py -O get-pip.py
sudo python2 get-pip.py
sudo pip install psycopg2-binary

sudo apt-get -qy purge 'libltdl*'

# python3-pip is a dependency for cfengine-nova-hub, so install that as well
sudo env DEBIAN_FRONTEND=noninteractive apt install -y python3-pip
