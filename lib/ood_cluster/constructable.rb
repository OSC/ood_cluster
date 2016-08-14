module OodCluster
  # Helper methods for breaking an object down into its components and
  # reconstructing it
  module Constructable
    # Construct an object from its class and initialization data
    # @param type [#to_s] name of the class
    # @param data [#to_h] hash used to initialize object
    # @return [Object] instantiated object
    def construct(type:, data:)
      Object.const_get(type.to_s).new data.to_h
    end

    # Deconstruct the object into its class and initialization data
    # @param obj [#to_h] object to deconstruct
    # @return [Hash] hash describing class and initialization data
    def deconstruct(obj)
      {
        type: obj.class.to_s,
        data: obj.to_h
      }
    end
  end
end
