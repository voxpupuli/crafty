# Minimal Systemd Setup for OpenVox

This example demonstrates a minimal setup of OpenVox using Systemd services to manage the OpenVoxServer, OpenVoxDB, and PostgreSQL.

## Usage

```shell
systemctl --user daemon-reload
systemctl --user start openvox-minimal-pod.service

# Test if the service is working
podman run --rm -it --network=systemd-crafty ghcr.io/openvoxproject/openvoxagent:latest agent -t --server openvoxserver


systemctl --user stop openvox-minimal-pod.service
podman network prune
```
