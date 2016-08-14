module OodCluster
  # An object that can be validated
  module Validatable
    # Whether this is a valid object
    # @example Whether I have access to this cluster
    #   my_cluster.valid?
    #   #=> true
    # @return [Boolean] whether this object is valid
    def valid?
      @validations.all?(&:valid?)
    end
  end
end
