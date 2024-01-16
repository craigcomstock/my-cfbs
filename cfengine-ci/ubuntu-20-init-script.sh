#!/bin/bash

# shellcheck disable=SC1091
. mender-qa/scripts/initialize-build-host.sh

# Add 512MB swap space, java needs it, and jenkins stops complaining.
sudo mender-qa/scripts/create_swap_file.sh 512

sudo apt-get -qy update
sudo apt-get -qy install bison flex binutils build-essential fakeroot ntp dpkg-dev libpam0g-dev debhelper pkg-config default-jre-headless psmisc libmodule-load-conditional-perl expat libexpat1-dev python3-psycopg2 gdb libtool autoconf libncurses5 python3-pip shellcheck 

# install python2 and psycopg2
sudo apt-get -qy install python
wget https://bootstrap.pypa.io/pip/2.7/get-pip.py -O get-pip.py
sudo python2 get-pip.py
sudo pip install psycopg2-binary

sudo apt-get -qy purge 'libltdl*'
