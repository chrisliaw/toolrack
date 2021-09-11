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
TR = ToolRack

ToolRack::DataConvUtils = Antrapol::ToolRack::DataConversionUtils
TR::DataConvUtils = ToolRack::DataConvUtils

ToolRack::CondUtils = ToolRack::ConditionUtils
TR::CondUtils = ToolRack::ConditionUtils

ToolRack::PassUtils = ToolRack::PasswordUtils
TR::PassUtils = ToolRack::PasswordUtils

ToolRack::ExpUtils = ToolRack::ExceptionUtils
TR::ExpUtils = ToolRack::ExpUtils

ToolRack::RTUtils = ToolRack::RuntimeUtils
TR::RTUtils = ToolRack::RTUtils

