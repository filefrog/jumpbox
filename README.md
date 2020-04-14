filefrog/clamav
===============

This image wraps up a ton of utilities and CLI tools that I find
to be useful / required for working in my current software stack,
whatever that may be.

(Currently, that's: BOSH + CF + K8s + Docker)

[See it on Docker Hub!][1]


Running it on Docker
--------------------

To run this in your local Docker daemon:

    docker run --rm -it filefrog/jumpbox /bin/bash

This will give you a shell.


Building (and Publishing) to Docker Hub
---------------------------------------

The Makefile handles building pushing.  For jhunt's:

    make push

Is all that's needed for release.  If you want to build it
locally, you can instead use:

    make build

If you want to tag it to your own Dockerhub username:

    IMAGE=you-at-dockerhub/jumpbox make build push

By default, the image is tagged `latest`.  You can supply your own
tag via the `TAG` environment variable:

   IMAGE=... TAG=$(date +%Y%m%d%H%M%S) make build push

Happy Hacking!


[1]: https://hub.docker.com/r/filefrog/jumpbox
