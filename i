set -e
set -x
if ! command -v pip 2>/dev/null; then
  echo "please install python3 and pip"
  exit 1
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
  cf-remote --version master install --clients localhost --edition community
fi
cf-promises -f ./out/masterfiles/promises.cf
cf-promises -f ./out/masterfiles/update.cf
cfbs install
#   error: cf-promises needs to be installed in /home/craig/.cfagent/bin for pre-validation of full configuration
#   error: Failsafe condition triggered. Interactive session detected, skipping failsafe.cf execution.
#   error: Error reading CFEngine policy. Exiting...
ln -sf $(which cf-promises) $HOME/.cfagent/bin/
# # cf-agent -I # non-priv user causes the following errors:
#    error: CfReadFile: Error while reading file '/sys/devices/virtual/dmi/id/product_serial' (Permission denied)
#    error: CfReadFile: Error while reading file '/sys/devices/virtual/dmi/id/product_serial' (Permission denied)
#    error: CfReadFile: Error while reading file '/sys/devices/virtual/dmi/id/product_uuid' (Permission denied)
#    error: CfReadFile: Error while reading file '/sys/devices/virtual/dmi/id/product_uuid' (Permission denied)
#    error: CfReadFile: Error while reading file '/sys/devices/virtual/dmi/id/product_serial' (Permission denied)
#    error: CfReadFile: Error while reading file '/sys/devices/virtual/dmi/id/product_serial' (Permission denied)
#    error: CfReadFile: Error while reading file '/sys/devices/virtual/dmi/id/product_uuid' (Permission denied)
#    error: CfReadFile: Error while reading file '/sys/devices/virtual/dmi/id/product_uuid' (Permission denied)
# Installed to /home/craig/.cfagent/inputs
#    error: CfReadFile: Error while reading file '/sys/devices/virtual/dmi/id/product_serial' (Permission denied)
#    error: CfReadFile: Error while reading file '/sys/devices/virtual/dmi/id/product_serial' (Permission denied)
#    error: CfReadFile: Error while reading file '/sys/devices/virtual/dmi/id/product_uuid' (Permission denied)
#    error: CfReadFile: Error while reading file '/sys/devices/virtual/dmi/id/product_uuid' (Permission denied)
#    error: CfReadFile: Error while reading file '/sys/devices/virtual/dmi/id/product_serial' (Permission denied)
#    error: CfReadFile: Error while reading file '/sys/devices/virtual/dmi/id/product_serial' (Permission denied)
#    error: CfReadFile: Error while reading file '/sys/devices/virtual/dmi/id/product_uuid' (Permission denied)
#    error: CfReadFile: Error while reading file '/sys/devices/virtual/dmi/id/product_uuid' (Permission denied)
#    error: CfReadFile: Error while reading file '/sys/devices/virtual/dmi/id/product_serial' (Permission denied)
#    error: CfReadFile: Error while reading file '/sys/devices/virtual/dmi/id/product_serial' (Permission denied)
#    error: CfReadFile: Error while reading file '/sys/devices/virtual/dmi/id/product_uuid' (Permission denied)
#    error: CfReadFile: Error while reading file '/sys/devices/virtual/dmi/id/product_uuid' (Permission denied)
#    error: CfReadFile: Error while reading file '/sys/devices/virtual/dmi/id/product_serial' (Permission denied)
#    error: CfReadFile: Error while reading file '/sys/devices/virtual/dmi/id/product_serial' (Permission denied)
#    error: CfReadFile: Error while reading file '/sys/devices/virtual/dmi/id/product_uuid' (Permission denied)
#    error: CfReadFile: Error while reading file '/sys/devices/virtual/dmi/id/product_uuid' (Permission denied)
#    error: CfReadFile: Error while reading file '/sys/devices/virtual/dmi/id/product_serial' (Permission denied)
#    error: CfReadFile: Error while reading file '/sys/devices/virtual/dmi/id/product_serial' (Permission denied)
#    error: CfReadFile: Error while reading file '/sys/devices/virtual/dmi/id/product_uuid' (Permission denied)
#    error: CfReadFile: Error while reading file '/sys/devices/virtual/dmi/id/product_uuid' (Permission denied)
#    error: CfReadFile: Error while reading file '/sys/devices/virtual/dmi/id/product_serial' (Permission denied)
#    error: CfReadFile: Error while reading file '/sys/devices/virtual/dmi/id/product_serial' (Permission denied)
#    error: CfReadFile: Error while reading file '/sys/devices/virtual/dmi/id/product_uuid' (Permission denied)
#    error: CfReadFile: Error while reading file '/sys/devices/virtual/dmi/id/product_uuid' (Permission denied)
#    error: CfReadFile: Error while reading file '/sys/devices/virtual/dmi/id/product_serial' (Permission denied)
#    error: CfReadFile: Error while reading file '/sys/devices/virtual/dmi/id/product_serial' (Permission denied)
#    error: CfReadFile: Error while reading file '/sys/devices/virtual/dmi/id/product_serial' (Permission denied)
#    error: CfReadFile: Error while reading file '/sys/devices/virtual/dmi/id/product_uuid' (Permission denied)
#    error: CfReadFile: Error while reading file '/sys/devices/virtual/dmi/id/product_uuid' (Permission denied)
#    error: CfReadFile: Error while reading file '/sys/devices/virtual/dmi/id/product_uuid' (Permission denied)
#    error: CfReadFile: Error while reading file '/sys/devices/virtual/dmi/id/product_serial' (Permission denied)
#    error: CfReadFile: Error while reading file '/sys/devices/virtual/dmi/id/product_serial' (Permission denied)
#     info: Executing 'no timeout' ... '/usr/sbin/dmidecode -t 17 | /bin/awk '/^\tSize:.*MB/ {a+=$2} /^\tSize:.*GB/ {b+=$2*1024} END {print a+b}' > '/home/craig/.cfagent/state/inventory-cfe_autorun_inventory_dmidecode-total-physical-memory-MB.txt''
#   notice: Q: ".../dmidecode -t 1": /sys/firmware/dmi/tables/smbios_entry_point: Permission denied
# Q: ".../dmidecode -t 1": /dev/mem: Permission denied
#     info: Last 2 quoted lines were generated by promiser '/usr/sbin/dmidecode -t 17 | /bin/awk '/^\tSize:.*MB/ {a+=$2} /^\tSize:.*GB/ {b+=$2*1024} END {print a+b}' > '/home/craig/.cfagent/state/inventory-cfe_autorun_inventory_dmidecode-total-physical-memory-MB.txt''
#     info: Completed execution of '/usr/sbin/dmidecode -t 17 | /bin/awk '/^\tSize:.*MB/ {a+=$2} /^\tSize:.*GB/ {b+=$2*1024} END {print a+b}' > '/home/craig/.cfagent/state/inventory-cfe_autorun_inventory_dmidecode-total-physical-memory-MB.txt''
#     info: Stored sha256 hash for '/etc/passwd' (SHA=4e38b52ce96d68a1ad01cfc7526583c4c27e09c21f856a2ae27b12fb66504900)
#     info: Stored sha256 hash for '/etc/group' (SHA=c1d00fb350842f396f33a2a046d2ee0627d6c8f85657a925716b92746ea10a2f)
#     info: Stored sha256 hash for '/etc/services' (SHA=1484dc11ec7c7c70c54ecd59e022f8348b6d58fd64532239a602e65915e4a8f0)
#     info: Cannot open file for hashing '/etc/shadow'. (fopen: Permission denied)
#     info: Stored sha256 hash for '/etc/shadow' (SHA=0000000000000000000000000000000000000000000000000000000000000000)
#     info: Cannot open file for hashing '/etc/shadow'. (fopen: Permission denied)
#    error: Cannot set ownership on file '/home/craig/.cfagent/state/./cf_state.lmdb.lock'. (chown: Operation not permitted)
#    error: Cannot set ownership on file '/home/craig/.cfagent/state/./cf_state.lmdb-lock'. (chown: Operation not permitted)
#    error: Cannot set ownership on file '/home/craig/.cfagent/state/./cf_state.lmdb'. (chown: Operation not permitted)
#    error: Cannot set ownership on file '/home/craig/.cfagent/state/./cf_lock.lmdb.lock'. (chown: Operation not permitted)
#    error: Cannot set ownership on file '/home/craig/.cfagent/state/./cf_lock.lmdb-lock'. (chown: Operation not permitted)
#    error: Cannot set ownership on file '/home/craig/.cfagent/state/./cf_lock.lmdb'. (chown: Operation not permitted)
#    error: Cannot set ownership on file '/home/craig/.cfagent/state/./promise_execution.log'. (chown: Operation not permitted)
#    error: Cannot set ownership on file '/home/craig/.cfagent/state/./inventory-cfe_autorun_inventory_dmidecode-total-physical-memory-MB.txt'. (chown: Operation not permitted)
#    error: Cannot set ownership on file '/home/craig/.cfagent/state/./promise_log.jsonl'. (chown: Operation not permitted)
#    error: Cannot set ownership on file '/home/craig/.cfagent/state/./performance.lmdb.lock'. (chown: Operation not permitted)
#    error: Cannot set ownership on file '/home/craig/.cfagent/state/./performance.lmdb-lock'. (chown: Operation not permitted)
#    error: Cannot set ownership on file '/home/craig/.cfagent/state/./performance.lmdb'. (chown: Operation not permitted)
#    error: Cannot set ownership on file '/home/craig/.cfagent/state/./cf_procs'. (chown: Operation not permitted)
#    error: Cannot set ownership on file '/home/craig/.cfagent/state/./cf_rootprocs'. (chown: Operation not permitted)
#    error: Cannot set ownership on file '/home/craig/.cfagent/state/./cf_otherprocs'. (chown: Operation not permitted)
#    error: Cannot set ownership on file '/home/craig/.cfagent/state/./cf_changes.lmdb.lock'. (chown: Operation not permitted)
#    error: Cannot set ownership on file '/home/craig/.cfagent/state/./cf_changes.lmdb-lock'. (chown: Operation not permitted)
#    error: Cannot set ownership on file '/home/craig/.cfagent/state/./cf_changes.lmdb'. (chown: Operation not permitted)
#    error: Errors encountered when actuating files promise '/home/craig/.cfagent/state/.'
#    error: Cannot set ownership on file '/home/craig/.cfagent/state/./previous_state'. (chown: Operation not permitted)
#    error: Cannot set ownership on file '/home/craig/.cfagent/state/./diff'. (chown: Operation not permitted)
#    error: Cannot set ownership on file '/home/craig/.cfagent/state/./untracked'. (chown: Operation not permitted)
#    error: Cannot set ownership on file '/home/craig/.cfagent/state/.'. (chown: Operation not permitted)
#    error: Errors encountered when actuating files promise '/home/craig/.cfagent/state/.'
#    error: Method 'cfe_internal_permissions' failed in some repairs
#    error: Method 'cfe_internal_enterprise_main' failed in some repairs
# so instead, run as root :(
# sudo: cfbs: command not found
sudo pip install cfbs # now it is installed twice?!
sudo cfbs install
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
  sudo cf-agent -IB localhost # self bootstrap for personal policy :)
fi
sudo cf-agent -I
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
#    error: Proposed executable file '/var/cfengine/bin/psql' doesn't exist
#    error: execresult '/var/cfengine/bin/psql cfsettings --quiet --tuples-only --command "SELECT COUNT(*) FROM remote_hubs" 2>/dev/null' is assumed to be executable but isn't
#    error: Proposed executable file '/var/cfengine/bin/psql' doesn't exist
#    error: execresult '/var/cfengine/bin/psql cfsettings --quiet --tuples-only --command "SELECT COUNT(*) FROM federated_reporting_settings" 2>/dev/null' is assumed to be executable but isn't
#    error: Proposed executable file '/var/cfengine/bin/psql' doesn't exist
#    error: execresult '/var/cfengine/bin/psql cfsettings --quiet --tuples-only --command "SELECT COUNT(*) FROM federated_reporting_settings" 2>/dev/null' is assumed to be executable but isn't
#    error: File '/var/cfengine/httpd/htdocs/application/config/config.php' could not be read in countlinesmatching(). (fopen: No such file or directory)
#    error: Proposed executable file '/var/cfengine/bin/psql' doesn't exist
#    error: execresult '/var/cfengine/bin/psql cfsettings --quiet --tuples-only --command "SELECT COUNT(*) FROM remote_hubs" 2>/dev/null' is assumed to be executable but isn't
#    error: Proposed executable file '/var/cfengine/bin/psql' doesn't exist
#    error: execresult '/var/cfengine/bin/psql cfsettings --quiet --tuples-only --command "SELECT COUNT(*) FROM remote_hubs" 2>/dev/null' is assumed to be executable but isn't
#    error: Proposed executable file '/var/cfengine/bin/psql' doesn't exist
#    error: execresult '/var/cfengine/bin/psql cfsettings --quiet --tuples-only --command "SELECT COUNT(*) FROM federated_reporting_settings" 2>/dev/null' is assumed to be executable but isn't
#    error: Proposed executable file '/var/cfengine/bin/psql' doesn't exist
#    error: execresult '/var/cfengine/bin/psql cfsettings --quiet --tuples-only --command "SELECT COUNT(*) FROM federated_reporting_settings" 2>/dev/null' is assumed to be executable but isn't
#    error: Proposed executable file '/var/cfengine/bin/psql' doesn't exist
#    error: execresult '/var/cfengine/bin/psql cfsettings --quiet --tuples-only --command "SELECT COUNT(*) FROM remote_hubs" 2>/dev/null' is assumed to be executable but isn't
#    error: Proposed executable file '/var/cfengine/bin/psql' doesn't exist
#    error: execresult '/var/cfengine/bin/psql cfsettings --quiet --tuples-only --command "SELECT COUNT(*) FROM remote_hubs" 2>/dev/null' is assumed to be executable but isn't
#    error: Proposed executable file '/var/cfengine/bin/psql' doesn't exist
#    error: execresult '/var/cfengine/bin/psql cfsettings --quiet --tuples-only --command "SELECT COUNT(*) FROM federated_reporting_settings" 2>/dev/null' is assumed to be executable but isn't
#    error: Proposed executable file '/var/cfengine/bin/psql' doesn't exist
#    error: execresult '/var/cfengine/bin/psql cfsettings --quiet --tuples-only --command "SELECT COUNT(*) FROM federated_reporting_settings" 2>/dev/null' is assumed to be executable but isn't
# 
# NOTE: switched to community package :)

# SUCCESS! CLEAN RUN!
output=$(sudo cf-agent | wc -l)
if [ "$output" != "0" ]; then
  echo "agent runs should have no output after bootstrapping!"
  exit 1
else
  echo "Congratulations! Everything is good! Promises kept!"
fi
