# Minimal Systemd Setup for OpenVox

This example demonstrates a minimal setup of OpenVox using Systemd services to manage the OpenVox compile servers.

## Prerequisites

Create Systemd Services for r10k and OpenVox Compiler by copying the service files from this directory.
The files should be placed in `/etc/containers/systemd/` for system-wide services or in `~/.config/containers/systemd/` for user services.
Adjust the services as needed, especially the paths to the volumes and networks.

## Usage

After setting up the Systemd services, you can enable and start them using the following commands:

```shell
systemctl --user daemon-reload
podman network create crafty-minimal
systemctl --user enable --now openvoxdb.service
systemctl --user enable --now openvox-compiler.service
systemctl --user enable --now postgresql.service
```
