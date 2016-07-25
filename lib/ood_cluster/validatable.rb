module OodCluster
  # An object that can be validated
  module Validatable
    # Whether this is a valid object
    # @example Whether I have access to this cluster
    #   my_cluster.valid?
    #   #=> true
    # @param force [Boolean] force it to always be valid
    # @return [Boolean] whether this object is valid
    def valid?(force = false)
      force || @validations.all?(&:valid?)
    end
  end
end
