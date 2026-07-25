# Base profile applied to all nodes
# @summary Configures base settings for all managed nodes
class profile::base {
  # Install node_exporter on all nodes for system metrics
  include profile::monitoring::node_exporter
}
