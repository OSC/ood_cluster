require 'ood_cluster/validatable'
module OodCluster
  # Object used to communicate with a batch server to retrieve reservation
  # information for current user
  class RsvQuery
    include Validatable

    # @param validations [Array<#valid?>] list of validations
    def initialize(validations: [], **_)
      @validations = validations
    end

    # Queries the batch server for a given reservation
    # @param cluster [Cluster] the cluster to query
    # @param id [#to_s] the id of the reservation
    # @return [Reservation, nil] the requested reservation
    # @abstract This should be implemented by the adapter
    def reservation(cluster:, id:)
      raise NotImplementedError
    end

    # Queries the batch server for a list of reservations
    # @param cluster [Cluster] the cluster to query
    # @return [Array<Reservation>] list of reservations
    # @abstract This should be implemented by the adapter
    def reservations(cluster:)
      raise NotImplementedError
    end
  end
end
