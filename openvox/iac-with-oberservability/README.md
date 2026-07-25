# Infrastructure as Code With Observability

## Abstract

This project demonstrates a zero-toil observability architecture for dynamic infrastructure fleets using OpenVox (Puppet), VictoriaMetrics, Vmagent, Caddy, and Grafana — all orchestrated through Docker Compose.

The core idea is that every node should self-register, self-classify, and self-instrument from the moment it boots, with no manual configuration file updates required.

Five implementation patterns underpin the architecture:

1. **CSR Classification** — nodes embed their role (`pp_role`) as a certificate extension at provisioning time, creating a tamper-proof, agent-immutable identity that drives all downstream automation.
2. **Pure Data Roles** — the Puppet site manifest contains zero classification logic; a single `lookup('classes', Array[String], 'unique').include` call delegates all node classification to Hiera YAML role files.
3. **Auto-Discovery via Exported Resources** — each node publishes its own scrape target to OpenVoxDB using Puppet exported resources; the metrics scraper collects them dynamically, eliminating static target lists entirely.
4. **Zero-Trust mTLS** — Caddy acts as a sidecar reverse proxy in front of every exporter, enforcing mutual TLS authenticated by the existing Puppet CA so only authorised scrapers can reach metrics endpoints.
5. **Layered Observability** — a `profile::base` class applies node-exporter to every host automatically, while Hiera role data layers on workload-specific exporters (e.g. Apache, PostgreSQL) only where needed.

## Ruby install
Use [rv](https://github.com/spinel-coop/rv) to install ruby. E.g.:
```shell
rv ruby install 3.3.10
```

## R10k install
Use the following to install [r10k](https://github.com/puppetlabs/r10k):
```shell
cd openvox-code
gem cleanup
bundle config set path vendor/bundle
bundle install
```

## Module dependencies
Use the following to install Puppet module dependencies:
```shell
cd openvox-code && bundle exec r10k puppetfile install
```

## Start
Use the following docker command:
```shell
docker compose up -d
```

## Teardown
Use the following commands to teardown:
```shell
docker compose down --volumes
rm -rf openvoxserver-ca openvoxserver-ssl
```

## Acknowledgements
This project is based on the excellent [OpenVox community](https://github.com/OpenVoxProject/) project and [crafty](https://github.com/voxpupuli/crafty).
100% thanks to them and all the contributors of the [VoxPupuli](https://voxpupuli.org/) community!
Their work has been instrumental in helping me understand the Puppet ecosystem and how to make it work for me.

## Further Reading
- [Roles and Profiles pattern](https://docs.openvoxproject.org/openvox/8.x/the_roles_and_profiles_method.html)
- [Exported Resources](https://docs.openvoxproject.org/openvox/8.x/lang_exported.html)
- [Certificate Extensions](https://docs.openvoxproject.org/openvox/8.x/ssl_attributes_extensions.html)
- [Hiera](https://docs.openvoxproject.org/openvox/8.x/hiera_intro.html)
- [Caddy](https://caddyserver.com/docs/)
- [VictoriaMetrics](https://docs.victoriametrics.com/)
- [Vmagent](https://docs.victoriametrics.com/victoriametrics/vmagent/)
- [Grafana](https://grafana.com/docs/)
