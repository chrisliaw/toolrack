require "toolrack/version"

require 'teLogger'
require 'singleton'

require 'fileutils'

require_relative 'toolrack/global'
require_relative 'toolrack/exception_utils'
require_relative 'toolrack/condition_utils'
require_relative 'toolrack/process_utils'
require_relative 'toolrack/runtime_utils'
require_relative 'toolrack/data_conversion_utils'
require_relative 'toolrack/password_utils'
require_relative 'toolrack/hash_config'
require_relative 'toolrack/cli_utils'
require_relative 'toolrack/null_output'
require_relative 'toolrack/version_utils'
require_relative 'toolrack/file_utils'
require_relative 'toolrack/block_params_utils'

module Antrapol
  module ToolRack
    class Error < StandardError; end
    # Your code goes here...
  end
end

# try to get rid of constant redefined warning
module TR
  Antrapol::ToolRack
end

# aliases
ToolRack = Antrapol::ToolRack
#TR = ToolRack

ToolRack::DataConvUtils = Antrapol::ToolRack::DataConversionUtils
TR::DataConvUtils = ToolRack::DataConvUtils

ToolRack::CondUtils = ToolRack::ConditionUtils
TR::CondUtils = ToolRack::ConditionUtils

TR::ProcessUtils = ToolRack::ProcessUtils

ToolRack::PassUtils = ToolRack::PasswordUtils
TR::PassUtils = ToolRack::PasswordUtils

ToolRack::ExpUtils = ToolRack::ExceptionUtils
TR::ExpUtils = ToolRack::ExpUtils

ToolRack::RTUtils = ToolRack::RuntimeUtils
TR::RTUtils = ToolRack::RTUtils

TR::HashConfig = ToolRack::HashConfig

TR::CliUtils = ToolRack::CliUtils

TR::NullOut = ToolRack::NullOutput

TR::VerUtils = ToolRack::VersionUtils
TR::VUtils = TR::VerUtils

TR::FileUtils = ToolRack::FileUtils

TR::BlockParamsUtils = ToolRack::BlockParamsUtils

