Demonstration of Blue-Green deployment without breaking sessions, with HAProxy
==============================================================================

Intro
-----

([See the blog post](http://theholyjava.wordpress.com/2013/08/23/blue-green-deployment-without-breaking-sessions-with-haproxy-and-jetty) for a more detailed explanation.)

Use case: Deploy a new version of a webapp so that all new users are sent to the new
version while users with open sessions continue using the previous version
(so that they don't loose their preciously built session state). Users of the new version
can explicitely ask for the previous version in the case that it doesn't work as expected.

Benefits: Get new features to users that need them as soon as possible without affecting
anybody negatively and without risking that a defect will prevent them from working
(for they can go back to the previous version)

Implementation: HAProxy in front of the instances (version) of the app (blue and green).
We always deploy to the "previous" version, thus making the "current" into a new "previous".
We inform the apps whether they should accept new users (yes for curent) via a POST request
and they communicate it further to HAProxy via its health checks.

Implementation
--------------

### Prerequisities

This proof of concept uses Vagrant to fire up and configure a virtual Linux machine. You could also run
it on an existing Linux machine, see `haproxy-vm/provision.sh`.

Vagrant will mount the `stateless-hello-webapp` directory in the VM as `/webapp/`.
The `haproxy-vm` directory itself is mounted as `/vagrant/`.

### Configuration

See the HAProxy configuration below `haproxy-vm/files/etc/`, it is mostly only copied from
[the documentation](http://haproxy.1wt.eu/download/1.3/doc/architecture.txt) (sections 4.1, 4.2).

### Deployment

TBD

* `haproxy-vm/switch-to-server.sh (blue|green|both)` will tell the instances to report themselves as available/unavailable
according to the argument.

TODO
----

* Deploy the webapp to two different paths and run if from there (so that we can deploy different versions)
* Make a deployment script that deployes to the current "previous" instance (and handles also the initial deployment)
* Make a (Gatling?) test to verify the sessions stay unbroken while all new requests go to the new instance
* Install Maven during provisioning

---
From the docs

The "force-persist" statement allows one to declare various ACL-based
  conditions which, when met, will cause a request to ignore the down status of
  a server and still try to connect to it. That makes it possible to start a
  server, still replying an error to the health checks, and run a specially
  configured browser to test the service. Among the handy methods, one could
  use a specific source IP address, or a specific cookie.
