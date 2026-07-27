class profile::monitoring::apache_exporter () {
  # Install apache_exporter
  $exporter_version = '1.0.12'
  $exporter_url = "https://github.com/Lusitaniae/apache_exporter/releases/download/v${exporter_version}/apache_exporter-${exporter_version}.linux-amd64.tar.gz"

  archive { '/tmp/apache_exporter.tar.gz':
    ensure       => present,
    source       => $exporter_url,
    extract      => true,
    extract_path => '/tmp',
    creates      => "/tmp/apache_exporter-${exporter_version}.linux-amd64/apache_exporter",
    cleanup      => true,
  }

  file { '/usr/local/bin/apache_exporter':
    ensure  => file,
    source  => "/tmp/apache_exporter-${exporter_version}.linux-amd64/apache_exporter",
    owner   => 'root',
    group   => 'root',
    mode    => '0755',
    require => Archive['/tmp/apache_exporter.tar.gz'],
  }

  $apache_exporter_port = 9117
  # Change the service resource to ensure it doesn't try to use systemd
  service { 'apache_exporter':
    ensure   => running,
    enable   => false, # Enable doesn't work without systemd
    provider => 'base',
    status   => '/usr/bin/pgrep -f apache_exporter',
    start    => "/usr/local/bin/apache_exporter --scrape_uri=http://127.0.0.1/server-status?auto --web.listen-address=127.0.0.1:${apache_exporter_port} > /var/log/apache_exporter.log 2>&1 &",
    stop     => '/usr/bin/pkill -f apache_exporter',
    require  => [
      File['/usr/local/bin/apache_exporter'],
      Service['apache2'],
    ],
  }

  profile::monitoring::exporter_config { 'apache':
    port    => $apache_exporter_port,
    require => Service['apache_exporter'],
  }
}
