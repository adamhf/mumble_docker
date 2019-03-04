docker-mumble
=============

A lean mumble container with mumble version 1.2.18, from Debian Stretch-Lite
 
[mumble_server.ini](http://wiki.mumble.info/wiki/Murmur.ini) goes in the /data/ volume mount or can be set with the environment variable MUMBLE_INI

to setup SuperUser password, change your run command from the default:
```
docker run -ti --rm adamhf/mumble_arm -supw supersecret
mumble-server does not own /data, attempting to modify
Failed to set initial capabilities
<W>2014-12-15 04:37:27.398 Initializing settings from /data/mumble_server.ini (basepath /data)
<W>2014-12-15 04:37:27.399 OpenSSL: OpenSSL 1.0.1j 15 Oct 2014
<C>2014-12-15 04:37:27.400 Successfully switched to uid 106
<C>2014-12-15 04:37:27.400 Failed to set initial capabilities
<W>2014-12-15 04:37:27.596 ServerDB: Opened SQLite database /data/murmur.sqlite
<W>2014-12-15 04:37:27.597 Generating new tables...
<F>2014-12-15 04:37:27.691 Superuser password set on server 1
```

start.sh handles /data volume permissions to match the debian mumble server user
