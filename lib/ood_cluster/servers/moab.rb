require 'open3'
require 'nokogiri'

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

      # Object used to make connections and communicate with a Moab scheduler
      # server
      class Scheduler
        # @param host [#to_s] the moab scheduler server
        # @param lib [#to_s] path to moab installation libraries
        # @param bin [#to_s] path to moab installation binaries
        # @param moabhomedir [#to_s] path to moab homedir
        def initialize(host:, lib:, bin:, moabhomedir:)
          @host        = host.to_s
          @lib         = Pathname.new(lib.to_s)
          @bin         = Pathname.new(bin.to_s)
          @moabhomedir = Pathname.new(moabhomedir.to_s)
        end

        # An exception raised when attempting to call Moab command that exits
        # with exit code other than 0
        class Error < StandardError; end

        # Call a binary command from the moab client installation
        # @param cmd [#to_s] command run from command line
        # @param args [Array<#to_s>] arguments for command
        # @return [Nokogiri::XML] the xml output from command
        # @raise [Error] if command line exits with nonzero exit code
        def call(cmd, *args)
          env = {
            # lib is not necessary for calling from command line
            "MOABHOMEDIR" => "#{@moabhomedir}"
          }
          cmd = @bin.join(cmd.to_s).to_s
          args = ["--host=#{@host}", "--xml"] + args.map(&:to_s)
          o, e, s = Open3.capture3(env, cmd, *args)
          s.success? ? Nokogiri::XML(o) : raise(Error, e)
        end
      end

      # The Moab object corresponding to this server used for communicating
      # with the server
      # @return [Scheduler] the moab scheduler server
      def moab
        Scheduler.new(host: host, lib: lib, bin: bin, moabhomedir: moabhomedir)
      end
    end
  end
end
