# vmagent profile
# @summary Installs and configures vmagent for metrics scraping
class profile::monitoring::vmagent {
  $vmagent_version = '1.142.0'
  $arch = $facts['os']['architecture'] ? {
    'aarch64' => 'arm64',
    'x86_64'  => 'amd64',
    default   => 'amd64',
  }

  file { "/tmp/vmutils-${vmagent_version}.linux-${arch}":
    ensure => directory,
    mode   => '0755',
  }

  archive { '/tmp/vmagent.tar.gz':
    ensure          => present,
    source          => "https://github.com/VictoriaMetrics/VictoriaMetrics/releases/download/v${vmagent_version}/vmutils-linux-${arch}-v${vmagent_version}.tar.gz",
    extract         => true,
    extract_path    => '/tmp',
    extract_command => "tar -xf %s --one-top-level=vmutils-${vmagent_version}.linux-${arch}",
    creates         => "/tmp/vmutils-${vmagent_version}.linux-${arch}/vmagent-prod",
    cleanup         => true,
    require         => File["/tmp/vmutils-${vmagent_version}.linux-${arch}"],
  }

  file { '/usr/local/bin/vmagent-prod':
    ensure  => file,
    source  => "/tmp/vmutils-${vmagent_version}.linux-${arch}/vmagent-prod",
    owner   => 'root',
    group   => 'root',
    mode    => '0755',
    require => Archive['/tmp/vmagent.tar.gz'],
  }

  file { '/etc/vmagent':
    ensure => directory,
    owner  => 'root',
    group  => 'root',
    mode   => '0755',
  }

  file { '/etc/vmagent/targets.d':
    ensure  => directory,
    owner   => 'root',
    group   => 'root',
    mode    => '0755',
    require => File['/etc/vmagent'],
  }

  # Collect all exported vmagent targets from all nodes
  # You may want to replace the following spaceship operator with PuppetDB query,
  # which is faster for large catalogs and scales better with node count.
  File <<| tag == 'vmagent_target' |>>

  # Copy Puppet CA for mTLS client authentication
  file { '/etc/vmagent/puppet-ca.pem':
    ensure => file,
    source => '/etc/puppetlabs/puppet/ssl/certs/ca.pem',
    owner  => 'root',
    group  => 'root',
    mode   => '0644',
  }

  # Copy vmagent client certificate (the vmagent host's puppet cert)
  file { '/etc/vmagent/client-cert.pem':
    ensure => file,
    source => "/etc/puppetlabs/puppet/ssl/certs/${facts['networking']['fqdn']}.pem",
    owner  => 'root',
    group  => 'root',
    mode   => '0644',
  }

  # Copy vmagent client private key
  file { '/etc/vmagent/client-key.pem':
    ensure => file,
    source => "/etc/puppetlabs/puppet/ssl/private_keys/${facts['networking']['fqdn']}.pem",
    owner  => 'root',
    group  => 'root',
    mode   => '0600',
  }

  service { 'vmagent':
    ensure   => running,
    enable   => false,
    provider => 'base',
    status   => '/usr/bin/pgrep -f vmagent-prod',
    start    => @(EOT/L),
      /usr/local/bin/vmagent-prod \
      -promscrape.config=/etc/prometheus/prometheus.yaml \
      -remoteWrite.url=http://victoria-metrics:8428/api/v1/write \
      -promscrape.fileSDCheckInterval=15s \
      > /var/log/vmagent.log 2>&1 &
      |EOT
    stop    => '/usr/bin/pkill -f vmagent-prod',
    require => [
      File['/usr/local/bin/vmagent-prod'],
      File['/etc/vmagent/targets.d'],
    ],
  }
}
