require 'ood_cluster/constructable'

module OodCluster
  # An object that describes a generic validation
  class Validation
    extend Constructable

    def initialize(**_)
    end

    # Convert object to hash
    # @return [Hash] the hash describing this object
    def to_h
      {}
    end

    # Whether this is valid
    # @return [Boolean] whether this is valid
    # @abstract This should be implemented in the inherited validation object
    def valid?
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
