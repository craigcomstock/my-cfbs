#!/bin/bash

sudo apt -qy --allow-change-held-packages install rsync curl build-essential

# shellcheck disable=SC1091
. mender-qa/scripts/initialize-build-host.sh

# Add 512MB swap space, java needs it, and jenkins stops complaining.
sudo mender-qa/scripts/create_swap_file.sh 512

sudo apt -qy --allow-change-held-packages install bison flex binutils build-essential fakeroot dpkg-dev libpam0g-dev debhelper pkg-config psmisc libmodule-load-conditional-perl expat libexpat1-dev python3-psycopg2 gdb default-jre libncurses5 libncurses5-dev python3-pip

sudo apt-get -qy purge libltdl7 libltdl-dev
