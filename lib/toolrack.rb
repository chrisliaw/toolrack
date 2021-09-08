require "toolrack/version"

require 'tlogger'
require 'singleton'

require 'fileutils'

require_relative 'toolrack/global'
require_relative 'toolrack/exception_utils'
require_relative 'toolrack/condition_utils'
require_relative 'toolrack/process_utils'
require_relative 'toolrack/runtime_utils'
require_relative 'toolrack/data_conversion_utils'
require_relative 'toolrack/password_utils'

module Antrapol
  module ToolRack
    class Error < StandardError; end
    # Your code goes here...
 
  end
end

ToolRack = Antrapol::ToolRack
ToolRack::DataConv = Antrapol::ToolRack::DataConversionUtils
ToolRack::CondUtils = ToolRack::ConditionUtils
ToolRack::PassUtils = ToolRack::PasswordUtils


