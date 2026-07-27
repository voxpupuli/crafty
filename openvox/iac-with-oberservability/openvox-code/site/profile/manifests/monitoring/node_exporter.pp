# Node exporter profile
# @summary Installs and configures node_exporter for system metrics monitoring
class profile::monitoring::node_exporter {
  # Install node_exporter
  $exporter_version = '1.11.1'
  $arch = $facts['os']['architecture'] ? {
    'aarch64' => 'arm64',
    'x86_64'  => 'amd64',
    default   => 'amd64',
  }

  archive { '/tmp/node_exporter.tar.gz':
    ensure       => present,
    source       => "https://github.com/prometheus/node_exporter/releases/download/v${exporter_version}/node_exporter-${exporter_version}.linux-${arch}.tar.gz",
    extract      => true,
    extract_path => '/tmp',
    creates      => "/tmp/node_exporter-${exporter_version}.linux-${arch}/node_exporter",
    cleanup      => true,
  }

  file { '/usr/local/bin/node_exporter':
    ensure  => file,
    source  => "/tmp/node_exporter-${exporter_version}.linux-${arch}/node_exporter",
    owner   => 'root',
    group   => 'root',
    mode    => '0755',
    require => Archive['/tmp/node_exporter.tar.gz'],
  }

  service { 'node_exporter':
    ensure   => running,
    enable   => false,
    provider => 'base',
    status   => '/usr/bin/pgrep -f node_exporter',
    start    => @(EOT/L),
      /usr/local/bin/node_exporter \
      --web.listen-address=127.0.0.1:9100 \
      "--collector.filesystem.mount-points-exclude=^/(dev|proc|sys|var/lib/docker/.+|var/lib/containers/.+)($|/)" \
      "--collector.netclass.ignored-devices=^(veth.*|docker.*|podman.*)$" \
      "--collector.netdev.device-exclude=^(veth.*|docker.*|podman.*)$" \
      > /var/log/node_exporter.log 2>&1 &
      |EOT
    stop     => '/usr/bin/pkill -f node_exporter',
    require  => [
      File['/usr/local/bin/node_exporter'],
    ],
  }

  profile::monitoring::exporter_config { 'node':
    port    => 9100,
    require => Service['node_exporter'],
  }
}
