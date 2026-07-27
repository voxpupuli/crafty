# @summary Defined type for managing Caddy configuration for monitoring exporters
#
# @param exporter_port Port for exporter
define profile::monitoring::exporter_config (
  Stdlib::Port::Unprivileged $port,
) {
  # include the main Caddy class
  include profile::monitoring::caddy

  # Caddy configuration snippet for this specific exporter
  file { "/etc/caddy/conf.d/${name}.caddy":
    ensure  => file,
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    content => @("EOT"),
      handle_path /${name}* {
        reverse_proxy localhost:${port}
      }
      | EOT
    require => [
      File['/etc/caddy/conf.d'],
      File['/etc/caddy/puppet-ca.pem'],
      File['/etc/caddy/node-cert.pem'],
      File['/etc/caddy/node-key.pem'],
    ],
    notify  => Service['caddy'],
  }

  # Export scrape target for vmagent
  @@file { "/etc/vmagent/targets.d/${facts['networking']['fqdn']}_${name}.yaml":
    ensure  => file,
    content => @("EOT"),
      # Managed by Puppet
      - targets:
          - ${facts['networking']['fqdn']}:9090/${name}/metrics
        labels:
          job: ${name}
          instance: ${facts['networking']['fqdn']}
          exporter: ${name}
      | EOT
    tag     => 'vmagent_target',
  }
}
