module OodCluster
  module Servers
    # This class defines a Moab server / client software installation
    class Moab < Server
      # The path to the installation location for this software's libraries
      # @example Locally installed Moab 8.1.1
      #   my_software.lib.to_s #=> "/usr/local/moab/8.1.1/lib"
      # @return [Pathname] the path to software libraries
      attr_reader :lib

      # The path to the installation location for this software's binaries
      # @example Locally installed Moab 8.1.1
      #   my_software.bin.to_s #=> "/usr/local/moab/8.1.1/bin"
      # @return [Pathname] the path to software binaries
      attr_reader :bin

      # The version of this software
      # @return [String] version of software
      attr_reader :version

      # The required Moab environment variable
      # @example
      #   my_software.moabhomedir #=> "/var/spool/batch/moab"
      # @return [Pathname] necessary environment variable
      attr_reader :moabhomedir

      # @param (see Server#initialize)
      # @param lib [#to_s] installation path of client software libraries
      # @param bin [#to_s] installation path of client software binaries
      # @param version [#to_s] version of client software
      # @param moabhomedir [#to_s] necessary environment variable
      def initialize(lib: "", bin: "", version:, moabhomedir: ENV['MOABHOMEDIR'], **kwargs)
        super(kwargs)

        # installation path
        @lib = Pathname.new(lib.to_s)
        @bin = Pathname.new(bin.to_s)

        # version number
        @version = version.to_s

        # necessary moab environment variable
        @moabhomedir = Pathname.new(moabhomedir.to_s)
      end

      # Convert object to hash
      # @return [Hash] the hash describing this object
      def to_h
        super.merge lib: @lib, bin: @bin, version: @version, moabhomedir: @moabhomedir
      end
    end
  end
end
