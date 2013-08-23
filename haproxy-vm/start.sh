#!/bin/bash
cd /webapp; /vagrant/apache-maven-3.1.0/bin/mvn jetty:run -Djetty.port=8000 -Denv=blue &> /tmp/blue.log &
cd /webapp; /vagrant/apache-maven-3.1.0/bin/mvn jetty:run -Djetty.port=9000 -Denv=green &> /tmp/green.log &
# Note: HAProxy should have already been running
