# CRAFTY - Containerized Resources And Funky Tools (in) YAML

[![Sponsored by betadots GmbH](https://img.shields.io/badge/Sponsored%20by-betadots%20GmbH-blue.svg)](https://www.betadots.de)
[![License](https://img.shields.io/github/license/voxpupuli/crafty.svg)](https://github.com/voxpupuli/crafty/blob/main/LICENSE)

## Crafty Project Overview

To see open issues and things which are in progress see:
[Crafty Overview](https://github.com/orgs/voxpupuli/projects/8/views/1).
This will give you a view over puppetdb, puppetserver and crafty itself.

## New version schema

The new version schema has the following layout:

```text
<puppet.major>.<puppet.minor>.<puppet.patch>-v<container.major>.<container.minor>.<container.patch>
```

Example usage:

```shell
docker run --name puppet --hostname puppet -v ./code:/etc/puppetlabs/code/ ghcr.io/voxpupuli/container-puppetserver:7.13.0-v1.1.3
docker run --link postgres:postgres --link puppet:puppet ghcr.io/voxpupuli/puppetdb:7.13.0-v1.2.1
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

In [puppet/oss](puppet/oss) we bundle puppetserver, puppetdb, postgres and puppetboard together.
We use the images from [voxpupuli/puppetserver](https://github.com/voxpupuli/container-puppetserver), [voxpupuli/puppetdb](https://github.com/voxpupuli/container-puppetdb) and [voxpupuli/puppetboard](https://github.com/voxpupuli/puppetboard) for this. For PostgreSQL we use `postgres:16-alpine`.

#### Generate additional certificates

After the puppet stack is running, execute the following commant to generate an additional certificate.
It will be put in the puppetserver-ssl volume, or any other volume you may have mounted for `/etc/puppetlabs/puppet/ssl`.

```bash
docker exec oss-puppet-1 puppetserver ca generate --certname puppetboard
```

Output:

```text
Successfully saved private key for puppetboard to /etc/puppetlabs/puppet/ssl/private_keys/puppetboard.pem
Successfully saved public key for puppetboard to /etc/puppetlabs/puppet/ssl/public_keys/puppetboard.pem
Successfully submitted certificate request for puppetboard
Successfully saved certificate for puppetboard to /etc/puppetlabs/puppet/ssl/certs/puppetboard.pem
Certificate for puppetboard was autosigned.
```

One can then mount the puppetserver-ssl or whatever mount one have to the additional container, which shall use the certs.
But in general this is a bad idea, but for testing this might work.

For the puppetboard, one also can specify the certs as base64 strings. To get the strings do:

```bash
docker exec oss-puppet-1 cat /etc/puppetlabs/puppet/ssl/certs/ca.pem | base64
docker exec oss-puppet-1 cat /etc/puppetlabs/puppet/ssl/certs/puppetboard.pem | base64
docker exec oss-puppet-1 cat /etc/puppetlabs/puppet/ssl/private_keys/puppetboard.pem | base64
```

#### Verify the setup

Run an agent against the new environment. After the run you should see a node in the puppetboard.
The puppetserver and puppetdb are not visible. They only have certificates from the ca, but no own agent running.

```bash
# on ARM64 set the platform, on AMD64 you might drop it
docker run -it --network crafty-oss --platform linux/amd64 ghcr.io/betadots/pdc:development puppet agent -t
```

### puppet/ha

In our [puppet/ha](puppet/ha) configuration, we have established a robust infrastructure consisting of a Certificate Authority (CA) server and three Puppet compile servers. To ensure high availability and efficient distribution of workloads, we've incorporated a NGINX load balancer. Additionally, there's a dedicated test node for thorough testing and validation.

For a comprehensive understanding of our setup, please refer to the detailed information provided in the dedicated [README.md](puppet/ha/README.md).

## How to release a container

see [docs/how-to-release.md](docs/how-to-release.md)

## Contributing

see [CONTRIBUTING.md](CONTRIBUTING.md)
