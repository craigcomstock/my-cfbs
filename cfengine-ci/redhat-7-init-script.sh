#!/bin/bash

# shellcheck disable=SC1091
. mender-qa/scripts/initialize-build-host.sh

# Add 512MB swap space, java needs it, and jenkins stops complaining.
sudo mender-qa/scripts/create_swap_file.sh 512

sudo yum -e 0 -d 0 -y update
sudo yum -e 0 -d 0 -y install gcc-c++ ncurses ncurses-devel pkgconfig rpm-build pam-devel ntp rsync gcc make perl-devel "perl(Digest::MD5)" perl-Data-Dumper perl-Module-Load-Conditional psmisc java-1.8.0-openjdk-headless expat-devel python-psycopg2 gdb xfsprogs "perl(IO::Uncompress::Gunzip)" "perl(JSON::PP)"

# from https://gitlab.com/Northern.tech/CFEngine/jenkins-vms/-/blob/master/machines/centos-7-x64/Vagrantfile
sudo yum -e 0 -d 0 -y install gettext wget which psmisc '@Development tools' ccache 'perl(ExtUtils::MakeMaker)' 'perl(Module::Load::Conditional)' tmux fakeroot python3 python3-pip 'perl(IPC::Cmd)' shellcheck

# We need to force reverse lookups of 127.0.0.1 to resolve to localhost.
# The default (resolve to the FQDN) disturbes the cf-serverd tests.
sudo sed -rie '/(127\.0\.0\.1|::1).*\{fqdn\}/d' /etc/cloud/templates/hosts.redhat.tmpl
sudo cloud-init single -n update_etc_hosts
