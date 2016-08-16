require 'ood_cluster/json_serializer'

module OodCluster
  # An object that describes a server hosted by a given cluster
  class Server
    include JsonSerializer

    # The host information for this server object
    # @example Host information for login node
    #   "my_server.host" #=> "oakley.osc.edu"
    # @return [String] the host for this server
    attr_reader :host

    # @param host [#to_s] host of server
    def initialize(host:, **_)
      @host = host.to_s
    end

    # Convert object to hash
    # @return [Hash] the hash describing this object
    def to_h
      {host: @host.to_s}
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
