#!/bin/bash

function fail {
  echo "FAILURE: $1"; exit 1
}

BINARY_NAME="stateless-hello-webapp-1.0-SNAPSHOT-war-exec.jar"
BINARY="/webapp/target/$BINARY_NAME"
APP_ROOT="/opt/myapp"
ZONE_FILE="$APP_ROOT/current_zone"
MVN=/vagrant/apache-maven-3.1.0/bin/mvn

lock="/tmp/deploy.lock"
# 0. Create/check a lock file
test -f $lock && fail "Deployment seems to be already in progress, $lock exists"
touch $lock || fail "Creating $lock failed"

# 1. Build the app if necessary
if [ ! -f $BINARY ]; then
  cd /webapp; $MVN package || fail "mvn package failed"
fi

# 2. Figure out the "previous" zone
current_zone=$(cat $ZONE_FILE)
if [ -z "$current_zone" ]; then current_zone="blue"; fi

if [ "blue" = "$current_zone" ]; then target_zone="green"; zone_port=9000; 
else target_zone="blue"; zone_port=8000
fi
echo ">> Current is $current_zone, deploying to $target_zone (at port $zone_port)"

# 3. Take prev down
# We should perhaps verify there are no active sessions...
pid=$(ps aux | grep -- "-Dzone=$target_zone" | cut -f1)
pid=$(ps -o pid,args -u vagrant | grep java | grep -- "-Dzone=$target_zone" | cut -f2 -d' ')
if [ ! -z "$pid" ]; then
  echo ">> Killing pid $pid"
  kill -9 $pid
  sleep 5
fi

# 4. Deploy and start the new version over prev
target="$APP_ROOT/$target_zone"
mkdir $target 2> /dev/null # if it did not exist ...
cp $BINARY $target
# start the app (in practice, we would use st. like upstart to run it as daemon)
# TBD Run the app as an upstart job (like mongodiffer)
echo ">>> Starting the app as: cd $target; java -Dzone=$target_zone -jar $BINARY_NAME -httpPort $zone_port &"
cd $target; java -Dzone=$target_zone -jar $BINARY_NAME -httpPort $zone_port &

# 5. Check it is working
# TBD check the app

# 6. Record the new "current" zone
echo $target_zone > $ZONE_FILE

# 7. Switch to it
/vagrant/switch-to-server.sh $target_zone

# 8. rm the lock
rm $lock
