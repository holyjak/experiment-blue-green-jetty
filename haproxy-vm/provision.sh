## Install and configure all SW necessary
# TODO Wget, unpack maven
echo ">>> Running apt-get update..."
apt-get update &> /dev/null

echo ">>> Installing packages..."
apt-get -yq install haproxy openjdk-7-jre-headless curl > /dev/null

echo ">>> Config, enable, and start haproxy"
cp -r /vagrant/files/etc/haproxy /etc/haproxy
cp /vagrant/files/etc/default/haproxy /etc/default/haproxy # necessary to enable it
service haproxy restart
