# CRAFTY - Containerized Resources And Funky Tools (in) YAML

[![Sponsored by betadots GmbH](https://img.shields.io/badge/Sponsored%20by-betadots%20GmbH-blue.svg)](https://www.betadots.de)
[![License](https://img.shields.io/github/license/voxpupuli/crafty.svg)](https://github.com/voxpupuli/crafty/blob/main/LICENSE)

## Crafty Project Overview

To see open issues and things which are in progress see:
[Crafty Overview](https://github.com/orgs/voxpupuli/projects/8/views/1).
This will give you a view over puppetdb, puppetserver and crafty itself.

## Version schema

The version schema has the following layout:

```text
<puppet.major>.<puppet.minor>.<puppet.patch>-v<container.major>.<container.minor>.<container.patch>
```

Example usage:

```shell
docker pull ghcr.io/voxpupuli/puppetserver:8.6.1-latest
```

| Name | Description |
| --- | --- |
| puppet.major | Describes the contained major Puppet version (7 or 8) |
| puppet.minor | Describes the contained minor Puppet version |
| puppet.patch | Describes the contained patchlevel Puppet version |
| container.major | Describes the major version of the base container (Ubunutu 22.04) or incompatible changes |
| container.minor | Describes new features or refactoring with backward compatibility |
| container.patch | Describes if minor changes or bugfixes have been implemented |

## Compose Examples

### puppet/oss

In the [puppet/oss](puppet/oss) example we bundle puppetserver, puppetdb, postgres, puppetboard and HDM together.

We use the images from

- [voxpupuli/puppetserver](https://github.com/voxpupuli/container-puppetserver)
- [voxpupuli/puppetdb](https://github.com/voxpupuli/container-puppetdb)
- [voxpupuli/puppetboard](https://github.com/voxpupuli/puppetboard)
- PostgreSQL 16 Alpine
- [betadots/hdm](https://github.com/betadots/hdm)

For a comprehensive understanding of our setup, please refer to the detailed information provided in the dedicated [README.md](puppet/oss/README.md).

### puppet/ha

In the [puppet/ha](puppet/ha) example, we have established a robust infrastructure consisting of a Certificate Authority (CA) server and three Puppet compile servers. To ensure high availability and efficient distribution of workloads, we've incorporated a NGINX load balancer. Additionally, there's a dedicated test node for thorough testing and validation.

For a comprehensive understanding of our setup, please refer to the detailed information provided in the dedicated [README.md](puppet/ha/README.md).

### puppet/minimal

In the [puppet/minimal](puppet/minimal) example we bundle puppetserver, puppetdb and postgres together.

For a comprehensive understanding of our setup, please refer to the detailed information provided in the dedicated [README.md](puppet/minimal/README.md).

### puppet/pps_only

In the [puppet/pps_only](puppet/pps_only/) example a puppetserver instance is started. For the ones who only want to run a standalone puppetserver without puppetdb. Mainly used for testing `voxpupuli/puppetserver` builds.

## Kubernetes

For a Helm-Chart using these containers have a look at: [puppetlabs/puppetserver-helm-chart](https://github.com/puppetlabs/puppetserver-helm-chart)

## How to release a container

see [RELEASE.md](RELEASE.md)

## Contributing

see [CONTRIBUTING.md](CONTRIBUTING.md)
