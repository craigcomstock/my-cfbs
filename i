set -ex
cfbs build
cfengine lint --strict no out/masterfiles/promises.cf
cfengine lint --strict no out/masterfiles/update.cf
