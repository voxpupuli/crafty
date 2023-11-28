# CRAFTY - Containerized Resources And Funky Tools (in) YAML

[![Sponsored by betadots GmbH](https://img.shields.io/badge/Sponsored%20by-betadots%20GmbH-blue.svg)](https://www.betadots.de)
[![License](https://img.shields.io/github/license/voxpupuli/crafty.svg)](https://github.com/voxpupuli/crafty/blob/main/LICENSE)

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
```
Successfully saved private key for puppetboard to /etc/puppetlabs/puppet/ssl/private_keys/puppetboard.pem
Successfully saved public key for puppetboard to /etc/puppetlabs/puppet/ssl/public_keys/puppetboard.pem
Successfully submitted certificate request for puppetboard
Successfully saved certificate for puppetboard to /etc/puppetlabs/puppet/ssl/certs/puppetboard.pem
Certificate for puppetboard was autosigned.
```

#### Verify the setup

Run an agent against the new environment. After the run you should see a node in the puppetboard.
The puppetserver and puppetdb are not visible. They only have certificates from the ca, but no own agent running.

```bash
# on ARM64 set the platform, on AMD64 you might drop it
docker run -it --network crafty-oss --platform linux/amd64 ghcr.io/betadots/pdc:development puppet agent -t
```

## How to release a container

see [docs/how-to-release.md](docs/how-to-release.md)

## Contributing

see [CONTRIBUTING.md](CONTRIBUTING.md)
