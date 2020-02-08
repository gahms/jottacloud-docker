#!/bin/bash

/etc/init.d/jottad start

while [[ "$(jotta-cli status)" =~ "ERROR  	jottad event loop has not started.*" ]]; do
  sleep 1
done

if [[ "$(jotta-cli status)" =~ "ERROR  Not logged in" ]]; then
  echo "First time login"
  
  # Login user
  /usr/bin/expect -c "
  set timeout 20
  spawn jotta-cli login
  expect \"accept license (yes/no): \" {send \"yes\n\"}
  expect \"Personal login token: \" {send \"$JOTTA_TOKEN\n\"}
  expect \"Devicename*: \" {send \"$JOTTA_DEVICE\n\"}
  expect eof
  "

  jotta-cli add /backup
else
  echo "User is logged in" 
fi

if [ -f /config/ignorefile ]; then
  echo "loading ignore file"
  jotta-cli ignores set /config/ignorefile
fi
  
echo "Setting scan interval to $JOTTA_SCANINTERVAL"
jotta-cli config set scaninterval $JOTTA_SCANINTERVAL

# put tail in the foreground, so docker does not quit
tail -f /dev/null

exec "$@"
