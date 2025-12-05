# CRAFTY Quadlets

## Prerequisites

Create Systemd Service for OpenVoxServer by copying the service files from this directory.
The files should be placed in `/etc/containers/systemd/` for system-wide services or in `~/.config/containers/systemd/` for user services.
Adjust the services as needed, especially the paths to the volumes and networks.

## Networking

it uses netavark as the network backend, and the network configuration is defined in the `crafty.network` file included in this directory.

The network unit is exceuting podman to create a network named `systemd-crafty` using the configuration from `crafty.network`. When stopped the service is stopped, but the podman network is not removed automatically, so you need to remove it manually using the command `podman network rm systemd-crafty`.

The network is configured in the `crafty.network` systemd unit, but the podman internal network is named `systemd-crafty`.

In systemd units refer to the network as `crafty.network`.
In podman refer to the network as `systemd-crafty` when using `--network` flag in podman commands for example.
