require "toolrack/version"

require 'tlogger'
require 'singleton'

require_relative 'toolrack/exception_utils'
require_relative 'toolrack/condition_utils'
#require_relative 'toolrack/process_utils'
require_relative 'toolrack/runtime_utils'

module Antrapol
  module ToolRack
    class Error < StandardError; end
    # Your code goes here...
 
    class GlobalConf
      include Singleton

    end

    class Logger
      include Singleton
      include Antrapol::ToolRack::ConditionUtils

      attr_reader :glogger
      def initialize
        # boolean
        loggerDebug = ENV['TOOLRACK_DEBUG']
        logFile = ENV['TOOLRACK_LOGFILE']
        maxLogNo = ENV['TOOLRACK_MAX_LOGFILE'] || 10
        logFileSize = ENV['TOOLRACK_MAX_LOGFILE_SIZE'] || 10*1024*1024
        
        if not is_empty?(loggerDebug) and loggerDebug
          @glogger = Tlogger.new(STDOUT)
        elsif not is_empty?(logFile)
          @glogger = Tlogger.new(logFile,maxLogNo,logFileSize)
        else
          @glogger = Tlogger.new('toolrack.log',maxLogNo,logFileSize)
        end
      end
    end
  
  end
end
