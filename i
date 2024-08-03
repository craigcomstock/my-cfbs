set -ex
#rm /tmp/*.json
#cf-agent -KIf ./docker_inventory.cf
cfbs build
cf-promises -f ./out/masterfiles/update.cf
cf-promises -f ./out/masterfiles/promises.cf
