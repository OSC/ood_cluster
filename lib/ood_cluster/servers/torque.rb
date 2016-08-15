require 'pbs'

module OodCluster
  module Servers
    # This class defines a Torque server / client software installation
    class Torque < Server
      # The path to the installation location for this software's libraries
      # @example Locally installed Torque v5.1.1
      #   my_software.lib #=> "/usr/local/torque/5.1.1/lib"
      # @return [Pathname] the path to software libraries
      attr_reader :lib

      # The path to the installation location for this software's binaries
      # @example Locally installed Torque v5.1.1
      #   my_software.bin #=> "/usr/local/torque/5.1.1/bin"
      # @return [Pathname] the path to software binaries
      attr_reader :bin

      # The version of this software
      # @return [String] version of software
      attr_reader :version

      # @param (see Server#initialize)
      # @param lib [#to_s] installation path of client software libraries
      # @param bin [#to_s] installation path of client software binaries
      # @param version [#to_s] version of client software
      def initialize(lib: "", bin: "", version:, **kwargs)
        super(kwargs)

        # installation path
        @lib = Pathname.new(lib.to_s)
        @bin = Pathname.new(bin.to_s)

        # version number
        @version = version.to_s
      end

      # Convert object to hash
      # @return [Hash] the hash describing this object
      def to_h
        super.merge lib: @lib, bin: @bin, version: @version
      end

      # The PBS object corresponding to this server
      # @return [PBS::Batch] the pbs batch server
      def pbs
        PBS::Batch.new(host: host, lib: lib, bin: bin)
      end
    end
  end
end
