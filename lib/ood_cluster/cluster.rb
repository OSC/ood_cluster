require 'yaml'
require 'ood_cluster/json_serializer'

module OodCluster
  # An object that describes a given cluster of nodes used by an HPC center
  class Cluster
    include JsonSerializer

    # @param servers [Hash{#to_sym=>Server}] hash of servers
    # @param hpc_cluster [Boolean] whether this is an hpc cluster
    def initialize(servers: {}, hpc_cluster: true, **_)
      @servers = servers.each_with_object({}) { |(k, v), h| h[k.to_sym] = v }
      @hpc_cluster = hpc_cluster
    end

    # Convert object to hash
    # @return [Hash] the hash describing this object
    def to_h
      {
        servers: @servers,
        hpc_cluster: @hpc_cluster
      }
    end

    # Whether this is an hpc-style cluster (i.e., meant for heavy computation)
    # @return [Boolean] whether this an hpc-style cluster
    def hpc_cluster?
      @hpc_cluster
    end

    # Grab object from {@servers} hash or check if it exists
    # @param method_name the method name called
    # @param arguments the arguments to the call
    # @param block an optional block for the call
    def method_missing(method_name, *arguments, &block)
      if /^(.+)_server$/ =~ method_name.to_s
        @servers.fetch($1.to_sym, nil)
      elsif /^(.+)_server\?$/ =~ method_name.to_s
        @servers.has_key?($1.to_sym)
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
