module OodCluster
  # An object that can be deserialized from YAML
  module Deserializable
    # Initialize object with proper defaults when deserializing YAML
    # @param coder [Psych::Coder] coder with deserialized data
    # @return [void]
    def init_with(coder)
      initialize(symbolize_keys(coder.map))
    end

    private
      # Symbolize keys in a hash
      def symbolize_keys(hash)
        hash.each_with_object({}) { |(k, v), h| h[k.to_sym] = v }
      end
  end
end
