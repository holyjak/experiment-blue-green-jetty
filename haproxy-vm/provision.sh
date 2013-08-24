## Install and configure all SW necessary
# TODO Wget, unpack maven
echo ">>> Running apt-get update..."
apt-get update &> /dev/null

echo ">>> Installing packages..."
# Note: JDK needed for compilation of the webapp
apt-get -yq install haproxy openjdk-7-jre-headless openjdk-7-jdk curl > /dev/null

echo ">>> Config, enable, and start haproxy"
cp -r /vagrant/files/etc/haproxy /etc/haproxy
cp /vagrant/files/etc/default/haproxy /etc/default/haproxy # necessary to enable it
service haproxy restart

# Setup
mkdir -p /opt/myapp
chown -R vagrant /opt/myapp
