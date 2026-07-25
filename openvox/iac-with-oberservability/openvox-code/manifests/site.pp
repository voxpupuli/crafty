# Site manifest for Hiera-based classification
# Nodes are classified via pp_role in their CSR attributes
# Roles are defined in Hiera YAML files, not Puppet manifests

node default {
  # Lookup classes from Hiera
  lookup('classes', Array[String], 'unique').include
}
