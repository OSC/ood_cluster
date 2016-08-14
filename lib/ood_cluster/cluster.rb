require 'yaml'
require 'ood_cluster/validatable'

module OodCluster
  # An object that describes a given cluster of nodes used by an HPC center
  class Cluster
    include Validatable

    # @param validations [Array<#to_h>] list of validations
    # @param servers [Hash{Symbol=>#to_h}] hash of servers
    # @param hpc_cluster [Boolean] whether this is an hpc cluster
    # @param rsv_query [nil,#to_h] reservation query object
    def initialize(validations: [], servers: {}, hpc_cluster: true, rsv_query: nil, **_)
      @validations = validations.map { |v| Validation.construct(v) }
      @servers = servers.to_h.each_with_object({}) { |(k, v), h| h[k] = Server.construct(v) }
      @hpc_cluster = hpc_cluster
      @rsv_query = rsv_query ? RsvQuery.construct(rsv_query) : nil
    end

    # Convert object to hash
    # @return [Hash] the hash describing this object
    def to_h
      {
        validations: @validations.map { |v| Validation.deconstruct(v) },
        servers: @servers.to_h.each_with_object({}) { |(k, v), h| h[k] = Server.deconstruct(v) },
        hpc_cluster: @hpc_cluster,
        rsv_query: @rsv_query ? RsvQuery.deconstruct(@rsv_query) : nil
      }
    end

    # Whether this is an hpc-style cluster (i.e., meant for heavy computation)
    # @return [Boolean] whether this an hpc-style cluster
    def hpc_cluster?
      @hpc_cluster
    end

    # Queries the batch server for a given reservation
    # @param id [#to_s] the id of the reservation
    # @return [Reservation, nil] the requested reservation
    def reservation(id)
      @rsv_query.reservation(cluster: self, id: id.to_s) if @rsv_query
    end

    # Queries the batch server for a list of reservations
    # @return [Array<Reservation>, nil] list of reservations
    def reservations
      @rsv_query.reservations(cluster: self) if @rsv_query
    end

    # Whether this cluster can query reservations
    # @return [Boolean] whether can handle reservation queries
    def reservations?
      !@rsv_query.nil? && @rsv_query.valid?
    end

    # Grab object from {@servers} hash or check if it exists
    # @param method_name the method name called
    # @param arguments the arguments to the call
    # @param block an optional block for the call
    def method_missing(method_name, *arguments, &block)
      if /^(.+)_server$/ =~ method_name.to_s
        @servers.fetch($1.to_sym, nil)
      elsif /^(.+)_server\?$/ =~ method_name.to_s
        @servers.has_key($1.to_sym)
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

    # The comparison operator
    # @param other [#to_h] object to compare against
    # @return [Boolean] whether objects are equivalent
    def ==(other)
      to_h == other.to_h
    end

    # Check whether objects are identical to each other
    # @param other [#to_h] object to compare against
    # @return [Boolean] whether objects are identical
    def eql?(other)
      self.class == other.class && self == other
    end

    # Generate a hash value for this object
    # @return [Fixnum] hash value of object
    def hash
      [self.class, to_h].hash
    end
  end
end
