module OodCluster
  # Helper methods for deserializing an object from JSON
  module Deserializable
    # Initialize object with data attribute hash
    # @param hsh [Hash{#to_sym=>Object}] hash used defining object
    # @return [self] newly instantiated object
    def json_create(hsh)
      new hsh["data"].each_with_object({}) { |(k, v), h| h[k.to_sym] = v }
    end
  end
end
