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
[the documentation](http://haproxy.1wt.eu/download/1.3/doc/architecture.txt) (sections 4.1, 4.2; only 
available for ve. 1.3, there might be better/other ways in newer version).

### Deployment

TBD

* `haproxy-vm/switch-to-server.sh (blue|green|both)` will tell the instances to report themselves as available/unavailable
according to the argument.

TODO
----

Important

* ! verify session not lost on prev upon deployment
    * Make a (Gatling?) test to verify the sessions stay unbroken while all new requests go to the new instance
* Inject the swtich+version panel via JS to make it easy to include

Nice to have

* Include current Revision/date in the JS pannel - from mvn build to mvn manifest to Java
* Cleanup
* What happens if having an old session but prev truly dies? (get 500 or st.)
* Google Analytics for version changes
* Rename health to status => /status/newest-version
* Deploy: verify we can curl the new version (and perhaps that we get the siwtching JS back)

### Resources

[HTML documentaton for HAProxy](https://code.google.com/p/haproxy-docs/wiki/AboutHTTP)
