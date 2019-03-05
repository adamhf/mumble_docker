#!/bin/bash
    
# set volume permissions
if [ "$(stat -c %U /data)" != "mumble-server" ] ; then 
  # SQLLite needs to be created by mumble-server / UID 106
  echo "mumble-server does not own /data, attempting to modify";
  chown -R mumble-server.mumble-server /data
fi; 

if [ ! -f /config/mumble_server.ini ]; then
    echo "No config file found in /config, copying in default file"
    cp /config-orig/mumble_server.ini /config/
    chown -R mumble-server.mumble-server /config
fi

OPTS="-ini $MUMBLE_INI"

exec murmurd $OPTS $@
