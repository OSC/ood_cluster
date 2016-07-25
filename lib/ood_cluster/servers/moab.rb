require 'open3'
require 'nokogiri'

module OodCluster
  module Servers
    # This class defines a Moab server / client software installation
    class Moab < Server
      # The path to the installation location for this software
      # @return [Pathname] the path to software installation location
      attr_reader :prefix

      # The version of this software
      # @return [String] version of software
      attr_reader :version

      # The required Moab environment variable
      # @return [Pathname] require moab env var
      attr_reader :moabhomedir

      # @param (see Server#initialize)
      # @param prefix [#to_s] installation path of client software
      # @param version [#to_s] version of client software
      # @param moabhomedir [#to_s] required moab env var
      def initialize(prefix:, version:, moabhomedir:, **kwargs)
        super(kwargs)

        # installation path
        @prefix = Pathname.new(prefix)
        raise ArgumentError, "prefix path doesn't exist (#{@prefix})" unless @prefix.exist?
        raise ArgumentError, "prefix not valid directory (#{@prefix})" unless @prefix.directory?

        # version number
        @version = version.to_s

        # required moab env var
        @moabhomedir = Pathname.new(moabhomedir)
        raise ArgumentError, "moabhomedir path doesn't exist (#{@moabhomedir})" unless @moabhomedir.exist?
        raise ArgumentError, "moabhomedir not valid directory (#{@moabhomedir})" unless @moabhomedir.directory?
      end

      # Object used to make connections and communicate with a Moab scheduler
      # server
      class Scheduler
        # The host of the Moab scheduler server
        # @example OSC's Oakley scheduler
        #   my_scheduler.host #=> "oak-batch.osc.edu"
        # @return [String] the moab scheduler host
        attr_reader :host

        # The path to the Moab client installation
        # @example For Moab 8.1.1
        #   my_scheduler.prefix.to_s #=> "/usr/local/moab/8.1.1"
        # @return [Pathname] path to moab installation
        attr_reader :prefix

        # The path to the Moab homedir
        # @example For default Moab installation
        #   my_scheduler.moabhomedir #=> "/var/spool/batch/moab"
        # @return [Pathname] path to moab homedir
        attr_reader :moabhomedir

        # @param host [#to_s] the moab scheduler server
        # @param prefix [#to_s] path to moab installation
        # @param moabhomedir [#to_s] path to moab homedir
        def initialize(host:, prefix:, moabhomedir:)
          @host        = host.to_s
          @prefix      = Pathname.new(prefix)
          @moabhomedir = Pathname.new(moabhomedir)
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
            "LD_LIBRARY_PATH" => "#{prefix.join('lib')}:#{ENV['LD_LIBRARY_PATH']}",
            "MOABHOMEDIR"     => "#{moabhomedir}"
          }
          cmd = prefix.join('bin', cmd.to_s).to_s
          args = args.map(&:to_s) + ["--host=#{host}", "--xml"]
          o, e, s = Open3.capture3(env, cmd, *args)
          s.success? ? Nokogiri::XML(o) : raise(Error, e)
        end
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

      # The Moab object corresponding to this server used for communicating
      # with the server
      # @return [Scheduler] the moab scheduler server
      def moab
        Scheduler.new(host: host, prefix: prefix, moabhomedir: moabhomedir)
      end

      # Convert object to hash
      # @return [Hash] the hash describing the object
      def to_h
        super.merge prefix: prefix, version: version, moabhomedir: moabhomedir
      end
    end
  end
end
