require 'json'

module OodCluster
  # Helper methods for serializing/deserializing an object from JSON
  module JsonSerializer
    # Sets class methods in any class that includes {JsonSerializer}
    def self.included(base)
      base.extend(ClassMethods)
    end

    # Namespace for class methods that extend object
    module ClassMethods
      # Initialize object with data attribute hash
      # @param object [Hash{#to_sym=>Object}] hash used defining object
      # @return [self] newly instantiated object
      def json_create(object)
        new object["data"].each_with_object({}) { |(k, v), h| h[k.to_sym] = v }
      end
    end

    # Serialize object into a json string
    def to_json(*args)
      {
        JSON.create_id => self.class.name,
        'data' => self.to_h
      }.to_json(*args)
    end
  end
end
