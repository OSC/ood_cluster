require 'ood_cluster/version'
require 'ood_cluster/cluster'
require 'ood_cluster/server'

# The main namespace for ood_cluster
module OodCluster
  # A namespace to hold all subclasses of {Server}
  module Servers
    require 'ood_cluster/servers/ssh'
    require 'ood_cluster/servers/torque'
    require 'ood_cluster/servers/moab'
    require 'ood_cluster/servers/ganglia'
  end
end
