#!/bin/bash

sudo apt-get -qy --force-yes install rsync curl

# shellcheck disable=SC1091
. mender-qa/scripts/initialize-build-host.sh

# Add 512MB swap space, java needs it, and jenkins stops complaining.
sudo mender-qa/scripts/create_swap_file.sh 512

sudo apt-get -qy --force-yes install bison flex binutils build-essential fakeroot ntp dpkg-dev libpam0g-dev python debhelper pkg-config psmisc libmodule-load-conditional-perl expat libexpat1-dev python3-psycopg2 gdb default-jre libncurses5 libncurses5-dev python3-pip

# install python2 and psycopg2
sudo apt-get -qy install python
wget https://bootstrap.pypa.io/pip/2.7/get-pip.py -O get-pip.py
sudo python2 get-pip.py
sudo pip install psycopg2-binary

sudo apt-get -qy --force-yes purge libltdl7 libltdl-dev
