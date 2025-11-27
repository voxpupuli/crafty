# CRAFTY - Containerized Resources And Funky Tools (in) YAML

[![Sponsored by betadots GmbH](https://img.shields.io/badge/Sponsored%20by-betadots%20GmbH-blue.svg)](https://www.betadots.de)
[![License](https://img.shields.io/github/license/voxpupuli/crafty.svg)](https://github.com/voxpupuli/crafty/blob/main/LICENSE)

## Crafty Project Overview

To see open issues and things which are in progress, have a look at the following project boards:

- [Vox Pupuli Container Overview](https://github.com/orgs/voxpupuli/projects/8/views/1)
- [OpenVoxProject Container Overview](https://github.com/orgs/OpenVoxProject/projects/4/views/1)

This will give you an idea what is planned and what is currently worked on.

## Version schema

The version schema has the following layout:

```text
<openvox.major>.<openvox.minor>.<openvox.patch>-v<container.major>.<container.minor>.<container.patch>
```

Example usage:

```shell
docker pull ghcr.io/openvoxproject/openvoxserver:8.8.0-latest
```

| Name | Description |
| --- | --- |
| openvox.major | Describes the contained major OpenVox version (7 or 8) |
| openvox.minor | Describes the contained minor OpenVox version |
| openvox.patch | Describes the contained patchlevel OpenVox version |
| container.major | Describes the major version of the base container (Ubunutu 22.04) or incompatible changes |
| container.minor | Describes new features or refactoring with backward compatibility |
| container.patch | Describes if minor changes or bugfixes have been implemented |

## Examples

### ha

In the [openvox/ha](openvox/ha) example, we have established a robust infrastructure consisting of a Certificate Authority (CA) server and three OpenVox compile servers. To ensure high availability and efficient distribution of workloads, we've incorporated a NGINX load balancer. Additionally, there's a dedicated test node for thorough testing and validation.

For a comprehensive understanding of our setup, please refer to the detailed information provided in the dedicated [README.md](openvox/ha/README.md).

### minimal

In the [openvox/minimal](openvox/minimal) example we bundle openvox-server, openvoxdb and postgres together.

For a comprehensive understanding of our setup, please refer to the detailed information provided in the dedicated [README.md](openvox/minimal/README.md).

### oss

In the [openvox/oss](openvox/oss) example we bundle openvoxserver, openvoxdb, postgres, puppetboard and HDM together.

We use the images from

- [openvoxproject/openvoxserver](https://github.com/openvoxproject/container-openvoxserver)
- [openvoxproject/openvoxdb](https://github.com/openvoxproject/container-openvoxdb)
- [openvoxproject/puppetboard](https://github.com/voxpupuli/puppetboard)
- PostgreSQL 16 Alpine
- [betadots/hdm](https://github.com/betadots/hdm)

For a comprehensive understanding of our setup, please refer to the detailed information provided in the dedicated [README.md](openvox/oss/README.md).

### r10k

In the [openvox/r10k](openvox/r10k) example we have a openvox-server with r10k setup to deploy puppet code from a git repository.

### standalone_server

In the [openvox/standalone_server](openvox/standalone_server) example a openvox-server instance is started.
For the ones who only want to run a standalone openvox-server without openvoxdb.
Mainly used for testing `openvoxproject/openvoxserver` builds.

## Kubernetes

For a Helm-Chart using these containers have a look at: [openvoxproject/openvox-helm-chart](https://github.com/OpenVoxProject/openvox-helm-chart)

## How to release a container

see [RELEASE.md](RELEASE.md)

## Contributing

see [CONTRIBUTING.md](CONTRIBUTING.md)
