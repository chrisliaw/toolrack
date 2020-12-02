require "toolrack/version"

require 'tlogger'
require 'singleton'

require 'fileutils'

require_relative 'toolrack/exception_utils'
require_relative 'toolrack/condition_utils'
require_relative 'toolrack/process_utils'
require_relative 'toolrack/runtime_utils'

module Antrapol
  module ToolRack
    class Error < StandardError; end
    # Your code goes here...
 
    class Logger
      include Singleton
      include Antrapol::ToolRack::ConditionUtils

      attr_reader :glogger
      def initialize
        # boolean
        loggerDebug = ENV['TOOLRACK_DEBUG']
        logFile = ENV['TOOLRACK_LOGFILE'] || File.join(Dir.home, 'antrapol_logs','toolrack.log')
        maxLogNo = ENV['TOOLRACK_MAX_LOGFILE'] || 10
        logFileSize = ENV['TOOLRACK_MAX_LOGFILE_SIZE'] || 10*1024*1024

        logFileDir = File.dirname(logFile)
        if not File.exist?(logFileDir)
          File.mkdir_p(logFileDir)
        end
        
        if not_empty?(loggerDebug) and (loggerDebug.downcase == 'true')
          @glogger = Tlogger.new(STDOUT)
        else
          @glogger = Tlogger.new(logFile,maxLogNo,logFileSize)
        end
      end
    end
  
  end
end
