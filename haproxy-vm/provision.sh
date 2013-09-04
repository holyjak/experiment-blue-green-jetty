## Install and configure all SW necessary
# TODO Wget, unpack maven
echo ">>> Running apt-get update..."
apt-get update &> /dev/null

echo ">>> Installing packages..."
# Note: JDK needed for compilation of the webapp
apt-get -yq install haproxy openjdk-7-jre-headless openjdk-7-jdk curl > /dev/null

echo ">>> Config, enable, and start haproxy"
cp -r /vagrant/files/etc/haproxy /etc
cp /vagrant/files/etc/default/haproxy /etc/default/haproxy # necessary to enable it
service haproxy restart

# Setup
mkdir -p /opt/myapp
chown -R vagrant /opt/myapp

echo ">>> Preparing maven..."
if [ ! -f "/vagrant/apache-maven-3.1.0/bin/mvn" ]; then
  wget http://apache.vianett.no/maven/maven-3/3.1.0/binaries/apache-maven-3.1.0-bin.tar.gz -O /tmp/maven.tgz
  tar xzvf /tmp/maven.tgz -C /vagrant
fi

# Setup the services
cp -vr /vagrant/files/etc/init /etc
