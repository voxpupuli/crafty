# @summary Configures Caddy reverse proxy with mTLS for secure metrics collection
class profile::monitoring::caddy () {
  # Binary Installation via Archive
  $caddy_version = '2.11.2'
  $arch = $facts['os']['architecture'] ? {
    'aarch64' => 'arm64',
    'x86_64'  => 'amd64',
    default   => 'amd64',
  }

  file { "/tmp/caddy-${caddy_version}.linux-${arch}":
    ensure => directory,
    mode   => '0755',
  }

  archive { '/tmp/caddy.tar.gz':
    ensure          => present,
    source          => "https://github.com/caddyserver/caddy/releases/download/v${caddy_version}/caddy_${caddy_version}_linux_${arch}.tar.gz",
    extract         => true,
    extract_path    => '/tmp',
    extract_command => "tar -xf %s --one-top-level=caddy-${caddy_version}.linux-${arch}",
    creates         => "/tmp/caddy-${caddy_version}.linux-${arch}/caddy",
    cleanup         => true,
    require         => File["/tmp/caddy-${caddy_version}.linux-${arch}"],
  }

  file { '/usr/local/bin/caddy':
    ensure  => file,
    source  => "/tmp/caddy-${caddy_version}.linux-${arch}/caddy",
    owner   => 'root',
    group   => 'root',
    mode    => '0755',
    require => Archive['/tmp/caddy.tar.gz'],
  }

  # Ensure Caddy config directory
  if ! defined(File['/etc/caddy']) {
    file { '/etc/caddy':
      ensure => directory,
      owner  => 'root',
      group  => 'root',
      mode   => '0755',
    }
  }

  # Ensure Caddy log directory
  if ! defined(File['/var/log/caddy']) {
    file { '/var/log/caddy':
      ensure => directory,
      mode   => '0755',
    }
  }

  # Ensure Caddy snippets directory for modular configs
  if ! defined(File['/etc/caddy/conf.d']) {
    file { '/etc/caddy/conf.d':
      ensure => directory,
      owner  => 'root',
      group  => 'root',
      mode   => '0755',
    }
  }

  # Copy Puppet CA certificate (only once)
  if ! defined(File['/etc/caddy/puppet-ca.pem']) {
    file { '/etc/caddy/puppet-ca.pem':
      ensure => file,
      source => '/etc/puppetlabs/puppet/ssl/certs/ca.pem',
      mode   => '0644',
    }
  }

  # Copy node certificate (only once)
  if ! defined(File['/etc/caddy/node-cert.pem']) {
    file { '/etc/caddy/node-cert.pem':
      ensure => file,
      source => "/etc/puppetlabs/puppet/ssl/certs/${facts['networking']['fqdn']}.pem",
      mode   => '0644',
    }
  }

  # Copy node private key (only once)
  if ! defined(File['/etc/caddy/node-key.pem']) {
    file { '/etc/caddy/node-key.pem':
      ensure => file,
      source => "/etc/puppetlabs/puppet/ssl/private_keys/${facts['networking']['fqdn']}.pem",
      mode   => '0600',
    }
  }


  # Main Caddyfile that imports all snippets (only create once)
  if ! defined(File['/etc/caddy/Caddyfile']) {
    file { '/etc/caddy/Caddyfile':
      ensure  => file,
      owner   => 'root',
      group   => 'root',
      mode    => '0644',
      content => @(EOT),
        {
          auto_https disable_redirects
        }

        :9090 {
          # Authenticate via Puppet CA with mTLS
          tls /etc/caddy/node-cert.pem /etc/caddy/node-key.pem {
            client_auth {
              mode require_and_verify
              trust_pool file /etc/caddy/puppet-ca.pem
            }
          }

          # Only allow the vmagent certificate (Common Name: vmagent.local)
          # Note: Match the CN exactly as it appears in the vmagent certificate
          @authorized_scrapers_snippet {
            expression \
              {tls_client_subject} == "CN=vmagent.local"
          }

          # Handle the authorized traffic by importing all exporter configurations
          handle @authorized_scrapers_snippet {
            import /etc/caddy/conf.d/*.caddy
          }

          # Block everything else (even other nodes with valid Puppet certs)
          handle {
            abort
          }
        }
        | EOT
      require => File['/etc/caddy'],
      notify  => Service['caddy'],
    }
  }

  # Caddy service (only define once)
  if ! defined(Service['caddy']) {
    service { 'caddy':
      ensure     => running,
      enable     => false,
      provider   => 'base',
      hasstatus  => true,
      hasrestart => true,
      # Use pgrep to find the caddy process
      status     => '/usr/bin/pgrep -f caddy',
      # Start Caddy using the config file and background it
      start      => '/usr/local/bin/caddy run --config /etc/caddy/Caddyfile --adapter caddyfile > /var/log/caddy/caddy.log 2>&1 &',
      stop       => '/usr/bin/pkill -f caddy',
      restart    => '/usr/local/bin/caddy reload --config /etc/caddy/Caddyfile --adapter caddyfile',
      require    => [
        File['/usr/local/bin/caddy'],
        File['/etc/caddy/Caddyfile'],
        File['/var/log/caddy'],
      ],
    }
  }
}
