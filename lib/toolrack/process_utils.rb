
require_relative 'global'
require_relative 'runtime_utils'

if Antrapol::ToolRack::RuntimeUtils.on_windows? or Antrapol::ToolRack::RuntimeUtils.on_mac?
  # pty causing "function 'openpty' not found in msvcrt.dll" in some
  # windows platform. Due to patches?
  Antrapol::ToolRack::Logger.instance.glogger.debug "On Windows or Mac. Not going to have gem 'pty' support"
else
  require 'pty'
end
require 'expect'
require 'io/console'
require 'teLogger'
require 'open3'



module Antrapol
  module ToolRack
    module ProcessUtils

      def exec(cmd, opts = { }, &block)
        type = opts[:exec_type]
        if not type.nil?
          instance(type, cmd, opts, &block)
        else
          instance(:basic, cmd, opts, &block)
        end
      end

      def instance(type, cmd, opts = { }, &block)
        case type
        when :basic
          Antrapol::ToolRack::Logger.instance.glogger.debug "Basic execution"
          basic_exec(cmd, &block)
        when :system
          Antrapol::ToolRack::Logger.instance.glogger.debug "System execution"
          system_exec(cmd, opts, &block)
        when :popen3
          Antrapol::ToolRack::Logger.instance.glogger.debug "Popen3 execution"
          popen3_exec(cmd, opts, &block)
        else
          Antrapol::ToolRack::Logger.instance.glogger.debug "Basic (fallback) execution"
          # basic
          basic_exec(cmd, &block) 
        end
      end

      private
      # backtick
      # backtick will only return at the end of the process.
      # If in the event there is a prompt to user, this should nto be used.
      def basic_exec(cmd, &block)
        Antrapol::ToolRack::Logger.instance.glogger.debug "Basic shell exec command : #{cmd}"
        res = `#{cmd}`
        if block
          block.call($?, res)
        else
          res
        end
      end # basic_shell_exec

      # system
      # System call link the stdout and stdin to the calling process and idea 
      # to call mild interactive process
      def system_exec(cmd, opts = { }, &block)
        Antrapol::ToolRack::Logger.instance.glogger.debug "System exec command : #{cmd}"
        system(cmd)
        $.
      end # system_exec

      #def popen_exec(cmd, opts = { }, &block)
      #  puts "Cmd : #{cmd}"
      #  IO.popen(cmd, "r+") do |io|
      #    puts io.gets
      #    puts io.gets
      #    puts io.gets
      #  end
      #end

      def popen3_exec(cmd, opts = { }, &block)
        Antrapol::ToolRack::Logger.instance.glogger.debug "Popen3 exec command : #{cmd}"
  			stdout, stderr, status = Open3.capture3(cmd)
        block.call(:popen_exec, { output: stdout, error: stderr, status: status })
      end

      def pty_exec(cmd, opts = { }, &block)
        
        Antrapol::ToolRack::Logger.instance.glogger.debug "PTY exec command : #{cmd}"

        # pty seems error running on windows + jruby
        if Antrapol::ToolRack::RuntimeUtils.on_windows?
          raise Exception, "You're running on Windows. There have been report that error \"function 'openpty' not found in msvcrt.dll\". Probably due to patches. For now pty_exec() shall be halted"
        end

        logger = opts[:logger] || Tlogger.new(STDOUT)
        expect = opts[:expect] || { }
        bufSize = opts[:intBufSize] || 1024000

        if bufSize != nil and bufSize.to_i > 0
        else
          bufSize = 1024000
        end

        logger.debug "Command : #{cmd}"
        PTY.spawn(cmd[0], *(cmd[1..-1])) do |pout,pin,pid| #, 'env TERM=ansi') do |stdout, stdin, pid|

          pin.sync = true

          begin
            loop do
              dat = []
              loop do
                d = pout.sysread(bufSize)
                dat << d
                break if d.length < bufSize
              end
              #dat = dat.join("\r\n")

              if block
                block.call(:inspect, { data: dat, output: pout, input: pin })
              end

            end
          rescue EOFError => ex
            logger.error "EOF : #{ex}"
            #clog "EOF reached. Waiting to kill process.", :debug, :os_cmd
            Process.wait(pid)
            #clog "Processed killed.", :debug, :os_cmd
          rescue Exception => ex
            logger.error ex.message
            logger.error ex.backtrace.join("\n")
            #clog ex.message, :error, :os_cmd
            #clog ex.backtrace.join("\n"), :error, :os_cmd
          end

        end
        # end PTY.spawn() method

        $?.exitstatus

      end # pty_exec

    end # module ProcessUtils

    class ProcessUtilsEngine
      extend ProcessUtils
    end
  end # module ToolRack
end # module Antrapol
