Demonstration of Blue-Green deployment without breaking sessions, with HAProxy
==============================================================================

Intro
-----

([See the blog post](http://theholyjava.wordpress.com/2013/08/23/blue-green-deployment-without-breaking-sessions-with-haproxy-and-jetty) for a more detailed explanation.)

Use case: Deploy a new version of a webapp so that all new users are sent to the new
version while users with open sessions continue using the previous version
(so that they don't loose their precious session state). Users of the new version
can explicitely ask for the previous version in the case that it doesn't work as expected and vice versa.

Benefits: Get new features to users that need them as soon as possible without affecting
anybody negatively and without risking that a defect will prevent users from achieving their goal
(thanks to being able to fall back to the previous version).

Implementation
--------------

### How to run this?

#### Via Vagrant

This PoC has been set up to run via Vagrant.

1. Install [Vagrant][1] and [VirtualBox][2]
2. Run `vagrant up` in `haproxy-vm/` directory to create and run the Vagrant virtual machine (VM)
3. Run `vagrant ssh` to ssh into the VM
4. You can now access the PoC webapp via HAProxy via `localhost:8080` from your computer and HAProxy's status page via `localhost:8081` (inside the VM they are at ports `80` and `81`)

Notice that Vagrant will mount the `stateless-hello-webapp` directory in the VM as `/webapp/` and
the `haproxy-vm` directory itself is mounted as `/vagrant/`.

[1]: http://vagrantup.com/
[2]: http://virtualbox.org/

#### On Linux

Copy the content of `haproxy-vm` to `/vagrant/` and the content of `stateless-hello-webapp` into `/webapp/` and run `haproxy-vm/provision.sh` as root. Access the app at ports `80` and `81`.

### How does it work?

HAProxy runs in front of the instances (versions) of the app (blue and green zones) (1).
We always deploy to the "previous" version, thus making the "current" into a new "previous" (2).
We inform the apps whether they should accept new users (yes for curent) via a POST request (3)
and they communicate it further to HAProxy via its health checks.

1. See `haproxy-vm/files/etc/haproxy/haproxy.cfg`
2. See `haproxy-vm/deploy-new-build.sh`
3. See `haproxy-vm/switch-to-server.sh`
4. See haproxy's config again, look for `option httpchk`


### Configuration

See the HAProxy configuration below `haproxy-vm/files/etc/`, it is mostly only copied from
[the documentation](http://haproxy.1wt.eu/download/1.3/doc/architecture.txt) (sections 4.1, 4.2; only
available for ve. 1.3, there might be better/other ways in newer version).

### Deployment

The script `haproxy-vm/deploy-new-build.sh` will build a new binary (unless it exists) and deploy it, switching the current
"current" and "old" zones. (It uses `haproxy-vm/switch-to-server.sh (blue|green|both)` to do the actual switch).

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
