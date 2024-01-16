#!/bin/bash

# shellcheck disable=SC1091
. mender-qa/scripts/initialize-build-host.sh

# Add 512MB swap space, java needs it, and jenkins stops complaining.
sudo mender-qa/scripts/create_swap_file.sh 512

# INF-3096, add --nobest to help these yum commands succeed
sudo yum --nobest -e 0 -d 0 -y update # 2022-11-15 rhel-9 needed --nobest in order to complete the update/upgrade
sudo yum --nobest -e 0 -d 0 -y install gcc-c++ ncurses ncurses-devel pkgconfig rpm-build pam-devel rsync gcc make gettext expat-devel sudo wget which psmisc '@Development tools' perl 'perl(ExtUtils::MakeMaker)' 'perl(Digest::MD5)' 'perl(Module::Load::Conditional)' python3 python3-psycopg2 tmux selinux-policy-devel openssl-devel

sudo rpm -iv https://kojipkgs.fedoraproject.org//packages/fakeroot/1.28/2.el9/x86_64/fakeroot-1.28-2.el9.x86_64.rpm https://kojipkgs.fedoraproject.org//packages/fakeroot/1.28/2.el9/x86_64/fakeroot-libs-1.28-2.el9.x86_64.rpm

sudo rpm -e --nodeps libtool-ltdl || true
sudo sed -ri 's/^%_enable_debug_packages/#\0/' /usr/lib/rpm/redhat/macros

sudo sed -ri 's/localhost //' /etc/hosts

# python3-pip is a dependency for cfengine-nova-hub to install cfbs, so install that as well
sudo yum --nobest -e 0 -d 0 -y install python3-pip
