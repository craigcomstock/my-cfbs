#!/bin/bash

# shellcheck disable=SC1091
. mender-qa/scripts/initialize-build-host.sh

# Add 512MB swap space, java needs it, and jenkins stops complaining.
sudo mender-qa/scripts/create_swap_file.sh 512

sudo yum --nobest -e 0 -d 0 -y update
sudo yum -e 0 -d 0 -y install gcc-c++ ncurses ncurses-devel pkgconfig rpm-build pam-devel rsync gcc make gettext expat-devel sudo wget which psmisc '@Development tools' perl 'perl(ExtUtils::MakeMaker)' 'perl(Digest::MD5)' 'perl(Module::Load::Conditional)' python2-psycopg2 python3 tmux selinux-policy-devel python2 openssl-devel

sudo rpm -iv https://kojipkgs.fedoraproject.org//packages/fakeroot/1.23/1.fc29/x86_64/fakeroot-1.23-1.fc29.x86_64.rpm https://kojipkgs.fedoraproject.org//packages/fakeroot/1.23/1.fc29/x86_64/fakeroot-libs-1.23-1.fc29.x86_64.rpm

sudo rpm -e --nodeps libtool-ltdl || true
sudo sed -ri 's/^%_enable_debug_packages/#\0/' /usr/lib/rpm/redhat/macros

sudo sed -ri 's/localhost //' /etc/hosts
