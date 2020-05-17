require "toolrack/version"

require 'tlogger'
require 'singleton'

require_relative 'toolrack/exception_utils'
require_relative 'toolrack/condition_utils'
require_relative 'toolrack/process_utils'
require_relative 'toolrack/runtime_utils'

module Antrapol
  module MyToolRack
    class Error < StandardError; end
    # Your code goes here...
  
    class Logger
      include Singleton
      include Antrapol::MyToolRack::ConditionUtils

      attr_reader :glogger
      def initialize
        loggerDebug = ENV['TOOLRACK_DEBUG']
        
        if is_empty?(loggerDebug) and loggerDebug
          @glogger = Tlogger.new(STDOUT)
        else
          @glogger = Tlogger.new('toolrack.log',10,10240000)
        end
      end
    end
  
  end
end
