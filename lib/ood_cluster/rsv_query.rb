require 'ood_cluster/validatable'
require 'ood_cluster/deserializable'

module OodCluster
  # Object used to communicate with a batch server to retrieve reservation
  # information for current user
  class RsvQuery
    extend Deserializable
    include Validatable

    # @param validations [Array<Validation>] list of validations
    def initialize(validations: [], **_)
      @validations = validations
    end

    # Convert object to hash
    # @return [Hash] the hash describing this object
    def to_h
      {
        validations: @validations
      }
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
