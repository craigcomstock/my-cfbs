cfbs build
docker run -v ./out/masterfiles:/var/lib/cfengine/inputs -it agent cf-promises
docker run -v ./out/masterfiles:/var/lib/cfengine/inputs -it agent cf-agent -KIf services/cfbs/tests/www-test.cf
