#!/usr/bin/env bash
set -e
dhcp_leases_file=$1

# optional: remove all unregistered hosts before importing from dhcp.leases file
#/var/cfengine/bin/psql cfdb -c "delete from __hosts where hostkey like 'unregistered%'"
#/var/cfengine/bin/psql cfdb -c "delete from __variables where hostkey like 'unregistered%'"
#/var/cfengine/bin/psql cfdb -c "delete from __contexts where hostkey like 'unregistered%'"
while IFS= read -r line
do
  mac=$(echo $line | awk '{print $2}')
  ipaddress=$(echo $line | awk '{print $3}')
  set -f # no globs in case of likely '*' in hostname field
  hostname=$(echo $line | awk '{print $4}')
  set +f
  mac_class="mac_"$(echo $mac | sed 's/:/_/g')
  hostkey=$(/var/cfengine/bin/psql cfdb --tuples-only -c "select hostkey from contexts where contextname = '"${mac_class}"'" | xargs)
  if [ -n "$hostkey" ]; then
    echo "found $hostkey for mac $mac"
    # TODO do anything? update?
  else
    echo "no host found for mac $mac"
    hostkey="unregistered_host_$mac"
    /var/cfengine/bin/psql cfdb -c "insert into __hosts values('$hostkey',null,to_timestamp(0)::date,to_timestamp(0)::date,0,null,'$ipaddress')"
    /var/cfengine/bin/psql cfdb -c "insert into __contexts values('$hostkey','$mac_class','{inventory,attribute_name=none,source=agent,hardclass}',null)"
    /var/cfengine/bin/psql cfdb -c "insert into __variables values('$hostkey','default','sys','fqhost','$hostname','string','default.sys.fqhost','{inventory,source=agent,"\""attribute_name=Host name"\""}',null);"
    /var/cfengine/bin/psql cfdb -c "insert into __variables values('$hostkey','default','sys','hardware_addresses','{"\"$mac\""}','slist','default.sys.hardware_addresses','{inventory,source=agent,"\""attribute_name=MAC addresses"\""}',null);"
    /var/cfengine/bin/psql cfdb -c "call update_inventory_by_hostkey('$hostkey')"
  fi
done <${dhcp_leases_file}
/var/cfengine/bin/psql cfdb -c "TRUNCATE TABLE ContextCache"
/var/cfengine/bin/psql cfdb -c "INSERT INTO ContextCache (hostkey, contextvector) SELECT hostkey, to_tsvector('simple',replace(x::text,'_','.')) FROM ( SELECT hostkey, array_agg(contextname) as x FROM __Contexts GROUP BY hostkey) as sub;"
