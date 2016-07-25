require 'addressable'

module OodCluster
  module Servers
    # This class defines a Ganglia server
    class Ganglia < Server
      # Template used to describe URI
      # @see https://www.rfc-editor.org/rfc/rfc6570.txt RFC describing template format
      TEMPLATE = '{+scheme}{host}{/segments*}{?query*}'

      # The scheme of the URI
      # @example Scheme of SSL protocol
      #   "my_ganglia.scheme" #=> "https://"
      # @return [String] scheme of uri
      attr_reader :scheme

      # The segments used to describe the path of the URI
      # @example Segments for URI with path "/ganglia/gweb.php"
      #   "my_ganglia.segments"
      #   #=> ["ganglia", "gweb.php"]
      # @return [Array<String>] segments of uri
      attr_reader :segments

      # The required query values of the URI
      # @example Required cluster query value
      #   "my_ganglia.req_query"
      #   #=> {c: "MyCluster"}
      # @return [Hash] required query values of uri
      attr_reader :req_query

      # Optional query values of the URI, these query values are
      # only defined if specified
      # NB: All optional values will be evaluated for string interpolations
      # @example Optional host query value
      #   "my_ganglia.opt_query"
      #   #=> {h: "%{h}.ten.osc.edu"}
      # @return [Hash] optional query values of uri
      attr_reader :opt_query

      # The version of this software
      # @return [String] version of software
      attr_reader :version

      # @param (see Server#initialize)
      # @param scheme [#to_s] the scheme used for URI
      # @param segments [Array<#to_s>] the segments used to construct path of URI
      # @param req_query [#to_h] hash of required query values used for URI
      # @param opt_query [#to_h] hash of optional query values if they exist
      # @param version [#to_s] version of server software
      def initialize(scheme:, segments: [], req_query: {}, opt_query: {}, version:, **kwargs)
        super(kwargs)

        # uri
        @scheme = scheme.to_s
        @segments = segments.map(&:to_s)
        @req_query = req_query.to_h
        @opt_query = opt_query.to_h

        # version
        @version = version.to_s
      end

      # The URI used to access information about given cluster
      # @param query [#to_h] user specified query hash
      # @return [Addressable] the uri for ganglia server
      def uri(query: {})
        Addressable::Template.new(TEMPLATE).expand({
          scheme: scheme,
          host: host,
          segments: segments,
          query: query_hash(query.to_h)
        })
      end

      # Convert object to hash
      # @return [Hash] the hash describing the object
      def to_h
        super.merge scheme: scheme, segments: segments, req_query: req_query, opt_query: opt_query, version: version
      end

      private
        # The full hash of query values used to construct URI
        def query_hash(query)
          req_query.merge(
            query.each_with_object({}) do |(k, v), h|
              h[k] = opt_query.has_key?(k) ? (opt_query[k] % req_query.merge(query)) : v
            end
          )
        end
    end
  end
end
