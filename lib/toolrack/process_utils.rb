
require 'pty'
require 'expect'
require 'io/console'
require 'tlogger'
require 'open3'


module Antrapol
  module MyToolRack
    module ProcessUtils

      # backtick
      # backtick will only return at the end of the process.
      # If in the event there is a prompt to user, this should nto be used.
      def basic_exec(cmd)
        Antrapol::MyToolRack::Logger.instance.glogger.debug "Basic shell exec command : #{cmd}"
        `#{cmd}`
      end # basic_shell_exec

      # system
      # System call link the stdout and stdin to the calling process and idea 
      # to call mild interactive process
      def system_exec(cmd, opts = { }, &block)
        Antrapol::MyToolRack::Logger.instance.glogger.debug "System exec command : #{cmd}"
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
        Antrapol::MyToolRack::Logger.instance.glogger.debug "Popen3 exec command : #{cmd}"
  			stdout, stderr, status = Open3.capture3(cmd)
        block.call(:popen_exec, { output: stdout, error: stderr, status: status })
      end

      def pty_exec(cmd, opts = { }, &block)
        
        Antrapol::MyToolRack::Logger.instance.glogger.debug "PTY exec command : #{cmd}"

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
  end # module MyToolRack
end # module Antrapol
