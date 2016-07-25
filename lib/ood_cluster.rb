require 'ood_cluster/version'
require 'ood_cluster/cluster'
require 'ood_cluster/server'
require 'ood_cluster/reservation'
require 'ood_cluster/rsv_query'

# The main namespace for ood_cluster
module OodCluster
  # A namespace to hold all subclasses of {Server}
  module Servers
    require 'ood_cluster/servers/torque'
    require 'ood_cluster/servers/moab'
    require 'ood_cluster/servers/ganglia'
  end

  # A namespace for validations that respond to {#valid?}
  module Validations
    require 'ood_cluster/validations/groups'
  end

  # A namespace to hold all subclasses of {RsvQuery}
  module RsvQueries
    require 'ood_cluster/rsv_queries/torque_moab'
  end
end
