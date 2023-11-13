# CRAFTY - Containerized Resources And Funky Tools (in) YAML

[![Sponsored by betadots GmbH](https://img.shields.io/badge/Sponsored%20by-betadots%20GmbH-blue.svg)](https://www.betadots.de)
[![License](https://img.shields.io/github/license/voxpupuli/crafty.svg)](https://github.com/voxpupuli/crafty/blob/main/LICENSE)

## puppet/oss
In [puppet/oss](puppet/oss) we bundle puppetserver, puppetdb and a postgres together.
We use the images from [voxpupuli/puppetserver](https://github.com/voxpupuli/container-puppetserver) and [voxpupuli/puppetdb](https://github.com/voxpupuli/container-puppetdb) for this. For the postgres we use upstream `postgres:16.0-alpine`

## How to release a container

see [docs/how-to-release.md](docs/how-to-release.md)
