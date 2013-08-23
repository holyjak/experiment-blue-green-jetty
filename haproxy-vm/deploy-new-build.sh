#!/bin/bash

echo "NOT YET IMPLEMENTED!"; exit 1

BINARY=/webapp/binary.jar
DEPLOY="/opt"

lock="/tmp/deploy.lock"
# 0. Create/check a lock file
if [ -f $lock ]; then echo "Deployment seems to be already in progress, $lock exists"; exit 1
touch $lock || exit 2

# 1. Build the app

# 2. Figure out the "previous" zone
current_zone=$(cat /var/run/myapp.zone)
if [ -z "$current_zone" ]; current_zone="blue"; fi
if [ "blue" = "$current_zone" ]; target_zone="green"; else target_zone="blue"; fi
echo ">> Current is $current_zone, deploying to $target_zone"

# 3. Take prev down
# We should perhaps verify there are no active sessions...
pid=$(ps aux | grep -- "-Dzone=$target_zone" | cut -f1)
echo ">> Killing pid $pid"
kill -9 $pid

# 4. Deploy and start the new version over prev
target="$DEPLOY/$target_zone"
mkdir $target 2> /dev/null # if it did not exist ...
cp $BINARY $target
# TBD start the app

# 5. Check it is working
# TBD check the app

# 6. Record the new "current" zone
echo $target_zone > /var/run/myapp.zone

# 7. Switch to it
/vagrant/switch-to-server.sh $target_zone

# 8. rm the lock
rm $lock
