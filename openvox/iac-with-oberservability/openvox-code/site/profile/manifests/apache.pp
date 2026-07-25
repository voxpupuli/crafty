# Apache web server profile
# @summary Installs and configures Apache with apache_exporter for monitoring
class profile::apache {
  # Install Apache without automatic service management
  class { 'apache':
    default_vhost  => true,
    service_manage => false, # don't manage boot-time enable/disable
    service_ensure => undef, # don't manage the running state
  }

  # Manually manage the service using the 'debian' provider
  service { 'apache2':
    ensure   => running,
    enable   => false,
    provider => 'debian',
    require  => Class['apache'],
  }

  # Ensure index.html works as DirectoryIndex
  class { 'apache::mod::dir':
    indexes => ['index.html'],
  }

  # Enable mod_status for metrics
  class { 'apache::mod::status':
    requires => 'ip 127.0.0.1',
  }

  # Create a simple index page
  file { '/var/www/html/index.html':
    ensure  => file,
    content => @("EOT"),
      <!DOCTYPE html>
      <html>
      <head><title>Apache Demo - ${facts['networking']['fqdn']}</title></head>
      <body>
        <h1>Apache Web Server</h1>
        <p>Hostname: ${facts['networking']['fqdn']}</p>
        <p>IP Address: ${facts['networking']['ip']}</p>
        <p>This server is managed by Puppet and monitored via VictoriaMetrics</p>
        <hr>
        <p><a href="/server-status">Server Status</a> (localhost only)</p>
      </body>
      </html>
      | EOT
    require => Class['apache'],
  }
}
