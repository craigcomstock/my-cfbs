#!/bin/bash

# shellcheck disable=SC1091
. mender-qa/scripts/initialize-build-host.sh

# Add 512MB swap space, java needs it, and jenkins stops complaining.
sudo mender-qa/scripts/create_swap_file.sh 512

# We need to force reverse lookups of 127.0.0.1 to resolve to localhost.
# The default (resolve to the FQDN) disturbes the cf-serverd tests.
sudo sed -rie '/(127\.0\.0\.1|::1).*\$\{fqdn\}/d' /etc/cloud/templates/hosts.redhat.tmpl
sudo cloud-init single -n update_etc_hosts

sudo yum -e 0 -d 0 -y update
sudo yum -e 0 -d 0 -y install gcc-c++ ncurses ncurses-devel pkgconfig rpm-build pam-devel ntp rsync gcc make perl-devel "perl(Digest::MD5)" perl-Data-Dumper perl-Module-Load-Conditional gettext java-1.8.0-openjdk-headless expat-devel python-psycopg2 gdb xfsprogs wget "perl(IO::Uncompress::Gunzip)" "perl(JSON::PP)" "perl(IPC::Cmd)"
