#!/bin/bash

set -eou pipefail

export DEBIAN_FRONTEND=noninteractive
apt-get update
apt-get install -y curl
curl -LR https://apt.voxpupuli.org/openvox8-release-ubuntu24.04.deb -o /tmp/openvox8-release-ubuntu24.04.deb
dpkg -i /tmp/openvox8-release-ubuntu24.04.deb
apt-get update
apt-get install -y openvox-agent

/opt/puppetlabs/bin/puppet config set server puppet --section main
/opt/puppetlabs/bin/puppet config set runinterval 60 --section main

mkdir -p /etc/puppetlabs/puppet
cat > /etc/puppetlabs/puppet/csr_attributes.yaml << 'EOF'
---
extension_requests:
  pp_role: webserver
EOF

echo 'Contacting OpenVox Server...'
/opt/puppetlabs/bin/puppet ssl bootstrap
echo 'Starting Puppet agent runs...'
while true; do
  /opt/puppetlabs/bin/puppet agent --test --detailed-exitcodes || [ $? -eq 2 ] || true
  sleep 300
done
