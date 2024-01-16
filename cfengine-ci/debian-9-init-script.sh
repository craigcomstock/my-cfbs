#!/bin/bash

# shellcheck disable=SC1091
. mender-qa/scripts/initialize-build-host.sh

# Add 512MB swap space, java needs it, and jenkins stops complaining.
sudo mender-qa/scripts/create_swap_file.sh 512

sudo apt-get -qy --force-yes install bison flex binutils build-essential fakeroot ntp dpkg-dev libpam0g-dev python debhelper pkg-config psmisc libmodule-load-conditional-perl expat libexpat1-dev python-psycopg2 gdb default-jre python3-pip

sudo apt-get -qy --force-yes purge libltdl7 libltdl-dev
