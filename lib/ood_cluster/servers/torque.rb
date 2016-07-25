require 'pbs'

module OodCluster
  module Servers
    # This class defines a Torque server / client software installation
    class Torque < Server
      # The path to the installation location for this software
      # @return [Pathname] the path to software installation location
      attr_reader :prefix

      # The version of this software
      # @return [String] version of software
      attr_reader :version

      # @param prefix [#to_s] installation path of client software
      # @param version [#to_s] version of client software
      def initialize(prefix:, version:, **kwargs)
        super(kwargs)

        # installation path
        @prefix = Pathname.new(prefix)
        raise ArgumentError, "prefix path doesn't exist (#{@prefix})" unless @prefix.exist?
        raise ArgumentError, "prefix not valid directory (#{@prefix})" unless @prefix.directory?

        # version number
        @version = version.to_s
      end

      # The path to Torque software library
      # @example Locally installed Torque v5.1.1
      #   "my_software.lib" #=> "/usr/local/torque/5.1.1/lib"
      # @return [Pathname] path to libraries
      def lib
        prefix.join('lib')
      end

      # The path to Torque software binaries
      # @example Locally installed Torque v5.1.1
      #   "my_software.lib" #=> "/usr/local/torque/5.1.1/bin"
      # @return [Pathname] path to binaries
      def bin
        prefix.join('bin')
      end

      # The PBS object corresponding to this server
      # @return [PBS::Batch] the pbs batch server
      def pbs
        PBS::Batch.new(host: host, prefix: prefix)
      end

      # Convert object to hash
      # @return [Hash] the hash describing the object
      def to_h
        super.merge prefix: prefix, version: version
      end
    end
  end
end
