Demonstration of Blue-Green deployment without breaking sessions, with HAProxy
==============================================================================

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
