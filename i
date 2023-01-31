#!/usr/bin/env sh
set -e
set -x
if ! command -v rsync 2>/dev/null; then
  if command -v apk 2>/dev/null; then
    sudo apk add rsync
  else
    # below needs sudo on debian. I added it for termux :)
    apt install rsync
  fi
  # todo need non-debian/termux package option :)
fi
if ! command -v pip 2>/dev/null; then
  if command -v apk 2>/dev/null; then
    sudo apk add python3 py3-pip
  elif command -v dnf 2>/dev/null; then
    sudo dnf install -y python3 python3-pip
  else
    echo "please install python3 and pip"
    exit 1
  fi
fi
if ! command -v cfbs 2>/dev/null; then
  pip install --upgrade cfbs
fi
cfbs build
# we need cfengine, install master on this host :) needs sudo right? :)
if ! command -v cf-remote 2>/dev/null; then
  pip install --upgrade cf-remote
fi
if ! command -v cf-agent 2>/dev/null; then
#  # todo, on termux, no sudo is needed
#  sudo apt install cfengine3 # debian alternate for cf-remote install command :)
#  sudo touch /var/lib/cfengine3/inputs/promises.cf # "bootstrap"
  cf-remote --version master install --clients localhost --edition community
fi
cf-promises -f ./out/masterfiles/promises.cf
cf-promises -f ./out/masterfiles/update.cf
#echo "alpine cant self bootstrap with default cfengine package"
#exit 0
if ! sudo command -v cfbs 2>/dev/null; then
  sudo pip install --upgrade cfbs
fi
sudo cfbs install
sudo cf-agent -KIf update.cf
sudo cf-agent -KI
exit 0 # local debian version
# with debian dist cfengine3 package the mpf is in a different location so use it
# just in case, lets touch the promises.cf in case we just installed cfengine3 package from debian repos
# sudo touch /var/lib/cfengine3/inputs/promises.cf # "bootstrap"
# ^^^ only for debian repo cfengine3 package
if [ -n "$TERMUX_VERSION" ]; then
  mpf_dir=$(cf-promises --show-vars=sys.masterdir | grep default: | awk '{print $2}'); rsync -avs out/masterfiles/ "$mpf_dir"
  cf-agent -KIf update.cf
  cf-agent -KI
else
  mpf_dir=$(sudo cf-promises --show-vars=sys.masterdir | grep default: | awk '{print $2}'); sudo rsync -avz out/masterfiles/ "$mpf_dir"
  sudo cf-agent -KIf update.cf # copy from masterfiles installed by cfbs to /var/cfengine/inputs
  sudo cf-agent -KI
fi
# if all that looks good, add changes and commit and push!
git add -p
git commit # so I get a chance to bounce out if I don't like the commit
git push
exit 0
# errors encountered when actuating files promise '/var/cfengine/inputs/cf_promises_validated'
# error: Method 'cfe_internal_update_policy_cpv' failed in some repairs
# try cf-agent as non-priv user, doesn't work well in many ways...
#   error: cf-promises needs to be installed in /home/craig/.cfagent/bin for pre-validation of full configuration
#   error: Failsafe condition triggered. Interactive session detected, skipping failsafe.cf execution.
#   error: Error reading CFEngine policy. Exiting...
# ln -sf $(which cf-promises) $HOME/.cfagent/bin/
# # cf-agent -I # non-priv user causes the following errors:
#    error: CfReadFile: Error while reading file '/sys/devices/virtual/dmi/id/product_serial' (Permission denied)
# --- snip --- many of these lines
#    error: Cannot set ownership on file '/home/craig/.cfagent/state/./untracked'. (chown: Operation not permitted)
#    error: Cannot set ownership on file '/home/craig/.cfagent/state/.'. (chown: Operation not permitted)
#    error: Errors encountered when actuating files promise '/home/craig/.cfagent/state/.'
#    error: Method 'cfe_internal_permissions' failed in some repairs
#    error: Method 'cfe_internal_enterprise_main' failed in some repairs
# so instead, run as root :(
# sudo: cfbs: command not found
#sudo cfbs install
# Successfully installed cfbs-3.2.8
# WARNING: Running pip as the 'root' user can result in broken permissions and conflicting behaviour with the system package manager. It is recommended to use a virtual environment instead: https://pip.pypa.io/warnings/venv
# Installed to /var/cfengine/masterfiles
#    error: There is no readable input file at '/var/cfengine/inputs/promises.cf'. (stat: No such file or directory)
#    error: Failsafe condition triggered. Interactive session detected, skipping failsafe.cf execution.
#    error: Error reading CFEngine policy. Exiting...
#  warning: Bootstrapping to loopback interface (localhost), other hosts will not be able to bootstrap to this server
#     info: Removing all files in '/var/cfengine/inputs'
#     info: Writing built-in failsafe policy to '/var/cfengine/inputs/failsafe.cf'
#     info: Assuming role as policy server, with policy distribution point at: /var/cfengine/masterfiles
# R: No public/private key pair is loaded, please create one by running "cf-key"
#   notice: cf-agent aborted on defined class 'no_ppkeys_ABORT_kept'
#    error: Bootstrapping failed, no input file at '/var/cfengine/inputs/promises.cf' after bootstrap
if ! sudo cf-key -p; then
 sudo cf-key # make a hostkey if not already there
fi
if ! sudo stat /var/cfengine/policy_server.dat; then
#  sudo cf-agent -IB raspberrypi # self bootstrap for personal policy :)
# use 127.0.0.1 instead of localhost, workaround for an issue I found
  sudo cf-agent -IB 127.0.0.1 # self bootstrap for personal policy :)
fi
#sudo cf-agent -I
# SUMMARY: basically OK to go, but many errors related to enterprise versus community policy server?
# R: Bootstrapping from host '127.0.0.1' via built-in policy '/var/cfengine/inputs/failsafe.cf'
# R: This host assumes the role of policy server
# R: Updated local policy from policy server
# R: Triggered an initial run of the policy
# R: Restarted systemd unit cfengine3
#   notice: Bootstrap to 'localhost' completed successfully!
# ++ sudo cf-agent -I
#    error: Proposed executable file '/var/cfengine/bin/psql' doesn't exist
#    error: execresult '/var/cfengine/bin/psql cfsettings --quiet --tuples-only --command "SELECT COUNT(*) FROM remote_hubs" 2>/dev/null' is assumed to be executable but isn't
# --- snip --- many lines like this, due to running cfengine-nova aka enterprise package, masterfiles notices enterprise package and expects the policy server to be a proper cfengine-nova-hub package with lots of things: postgresql, apache, mission-portal, etc
# 
# NOTE: switched to community package :)

# SUCCESS! CLEAN RUN!
# break something
sudo mkdir -p /home/guest/.local
sudo touch /home/guest/.local/foo
sudo chown root /home/guest/.local/foo
sudo cf-agent -KI | tee agent.log
#if [ $(cat agent.log | wc -l) != "0" ]; then
#  echo "agent runs should have no output after bootstrapping!"
#  exit 1
#else
#  echo "Congratulations! Everything is good! Promises kept!"
#fi
grep guest /etc/passwd # should show up
sudo ls -l /home/guest # should be there!
echo "SUCCESS!"
# ugh! can't self bootstrap with community?
#   228  cf-agent -IB localhost
#  229  cp -R ../masterfiles/* .
#  230  cf-agent -KIf update.cf
#  231  cf-agent -KI
