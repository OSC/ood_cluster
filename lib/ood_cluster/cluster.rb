require 'yaml'
require 'ood_cluster/validatable'

module OodCluster
  # An object that describes a given cluster of nodes used by an HPC center
  class Cluster
    include Validatable

    # @param validations [Array<#valid?>] list of validations
    # @param servers [#to_h] hash of servers
    # @param hpc_cluster [Boolean] whether this is an hpc cluster
    # @param rsv_query [RsvQuery] reservation query object
    def initialize(validations: [], servers: {}, hpc_cluster: true, rsv_query: nil, **_)
      @validations = validations
      @servers = servers.to_h
      @hpc_cluster = hpc_cluster
      @rsv_query = rsv_query
    end

    # Whether this is an hpc-style cluster (i.e., meant for heavy computation)
    # @return [Boolean] whether this an hpc-style cluster
    def hpc_cluster?
      @hpc_cluster
    end

    # Queries the batch server for a given reservation
    # @param id [#to_s] the id of the reservation
    # @param force [Boolean] whether we skip validation
    # @return [Reservation, nil] the requested reservation
    def reservation(id, force: false)
      @rsv_query.reservation(cluster: self, id: id.to_s) if reservations?(force)
    end

    # Queries the batch server for a list of reservations
    # @param force [Boolean] whether we skip validation
    # @return [Array<Reservation>, nil] list of reservations
    def reservations(force: false)
      @rsv_query.reservations(cluster: self) if reservations?(force)
    end

    # Whether this cluster can query reservations
    # @return [Boolean] whether can handle reservation queries
    def reservations?(force = false)
      !@rsv_query.nil? && @rsv_query.valid?(force)
    end

    # Grab object from {@servers} hash or check if it exists
    # @param method_name the method name called
    # @param arguments the arguments to the call
    # @param block an optional block for the call
    def method_missing(method_name, *arguments, &block)
      if /^(.+)_server$/ =~ method_name.to_s
        @servers.fetch($1) { @session.fetch($1.to_sym, nil) }
      elsif /^(.+)_server\?$/ =~ method_name.to_s
        @servers.has_key?($1) || @servers.has_key($1.to_sym)
      else
        super
      end
    end

    # Check if method ends with custom *_server or *_server?
    # @param method_name the method name to check
    # @return [Boolean]
    def respond_to_missing?(method_name, include_private = false)
      method_name.to_s.end_with?('_server', '_server?') || super
    end
  end
end
