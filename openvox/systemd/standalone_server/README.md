# Minimal Systemd Setup for OpenVox

This example demonstrates a standalone server setup.

## Usage

```shell
# Start the OpenVoxServer service
systemctl --user daemon-reload
systemctl --user start openvoxserver.service

# Test if the service is working
podman run --rm -it --network=systemd-crafty ghcr.io/openvoxproject/openvoxagent:latest agent -t --server openvoxserver

# Stop the OpenVoxServer service
systemctl --user stop openvoxserver.service
podman network prune
```
