#!/bin/bash

sudo env DEBIAN_FRONTEND=noninteractive apt-get update
sudo env DEBIAN_FRONTEND=noninteractive apt-get -qy upgrade
sudo env DEBIAN_FRONTEND=noninteractive apt-get -qy --force-yes install rsync curl

# shellcheck disable=SC1091
. mender-qa/scripts/initialize-build-host.sh

# Add 512MB swap space, java needs it, and jenkins stops complaining.
sudo mender-qa/scripts/create_swap_file.sh 512

sudo env DEBIAN_FRONTEND=noninteractive apt-get -qy --force-yes install ca-certificates-java || true # install this before default-jre otherwise we get failures, see https://bugs.launchpad.net/ubuntu/+source/ca-certificates-java/+bug/1998065
sudo env DEBIAN_FRONTEND=noninteractive apt-get -qy --force-yes install ca-certificates-java # do it another time, seems to clear things up
sudo env DEBIAN_FRONTEND=noninteractive apt-get -qy --force-yes install bison flex binutils build-essential fakeroot ntp dpkg-dev libpam0g-dev python debhelper pkg-config psmisc libmodule-load-conditional-perl expat libexpat1-dev python-psycopg2 gdb default-jre libncurses5 libncurses5-dev python3-pip

sudo env DEBIAN_FRONTEND=noninteractive apt-get -qy --force-yes purge libltdl7 libltdl-dev
