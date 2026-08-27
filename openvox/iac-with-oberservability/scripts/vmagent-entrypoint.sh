#!/bin/sh

set -eu -o pipefail

mkdir -p /etc/puppetlabs/puppet
touch /etc/puppetlabs/puppet/puppet.conf

puppet config set server puppet --section main
puppet config set runinterval 60 --section main

cat > /etc/puppetlabs/puppet/csr_attributes.yaml << 'EOF'
---
extension_requests:
  pp_role: monitoring_scraper
EOF

echo 'Contacting OpenVox Server...'
puppet ssl bootstrap
echo 'Starting Puppet agent runs...'
while true; do
  puppet agent --test --detailed-exitcodes || [ $? -eq 2 ] || true
  sleep 300
done
