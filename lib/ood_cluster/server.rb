module OodCluster
  # An object that describes a server hosted by a given cluster
  class Server
    # The host information for this server object
    # @example Host information for login node
    #   "my_server.host" #=> "oakley.osc.edu"
    # @return [String] the host for this server
    attr_reader :host

    # @param host [#to_s] host info
    def initialize(host:, **_)
      @host = host.to_s
    end

    # Convert object to hash
    # @return [Hash] the hash describing this object
    def to_h
      {host: host}
    end

    # The comparison operator
    # @param other [#to_h] server to compare against
    # @return [Boolean] how servers compare
    def ==(other)
      to_h == other.to_h
    end

    # Checks whether two server objects are completely identical to each other
    # @param other [Server] server to compare against
    # @return [Boolean] whether same objects
    def eql?(other)
      self.class == other.class && self == other
    end

    # Generates a hash value for this object
    # @return [Fixnum] hash value of object
    def hash
      [self.class, to_h].hash
    end
  end
end
