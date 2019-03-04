#!/bin/bash
    
# set volume permissions
if [ "$(stat -c %U /data)" != "mumble-server" ] ; then 
  # SQLLite needs to be created by mumble-server / UID 106
  echo "mumble-server does not own /data, attempting to modify";
  chown -R mumble-server.mumble-server /data
fi; 

OPTS="-ini $MUMBLE_INI"

exec murmurd $OPTS $@
