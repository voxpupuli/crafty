#!/bin/bash

set -eou pipefail

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
