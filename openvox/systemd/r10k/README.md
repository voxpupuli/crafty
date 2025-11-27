# r10k with Systemd

This example demonstrates how to set up r10k with Systemd services to manage OpenVox compile servers.

## Prerequisites

Create Systemd Services for r10k and OpenVox Compiler by copying the service files from this directory.
The files should be placed in `/etc/containers/systemd/` for system-wide services or in `~/.config/containers/systemd/` for user services.
Adjust the services as needed, especially the paths to the volumes and networks.

## Usage

After setting up the Systemd services, you can enable and start them using the following commands:

```shell
systemctl daemon-reload

podman volume create code_dir ssl_dir ca_dir
podman network create crafty-r10k

systemctl enable --now openvox-ca.service
systemctl start r10k-deploy.service

systemctl enable --now openvox-compiler@001.service
systemctl enable --now openvox-compiler@002.service
systemctl enable --now openvox-compiler@003.service

systemctl start r10k-deploy.service
```
