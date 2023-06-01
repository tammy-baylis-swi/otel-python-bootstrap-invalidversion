# otel-python-bootstrap-invalidversion

Sample code to reproduce `opentelemetry-bootstrap` setuptools/pkg_resources error in Ubuntu:

`pkg_resources.extern.packaging.version.InvalidVersion: Invalid version: '0.23ubuntu1'`

## Prerequisites

* docker
* docker-compose

## Run opentelemetry-bootstrap in Ubuntu

### InvalidError

_May 31 2023:_ This no longer results in InvalidError.

Run opentelemetry-bootstrap with Python 3.10 on Ubuntu 20.04:
`docker-compose run --rm py3.10-install-ubuntu20.04`

### No error, Flask app runs

Run opentelemetry-bootstrap with Python 3.10 on Ubuntu 20.04, and installs older `setuptools` version:
`docker-compose run --rm py3.10-install-ubuntu20.04-old-setuptools`

Run opentelemetry-bootstrap with Python 3.7 on Ubuntu 18.04:
`docker-compose run --rm py3.7-install-ubuntu18.04`
