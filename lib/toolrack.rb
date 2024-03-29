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
require_relative 'toolrack/terminal_utils'
require_relative 'toolrack/arg_utils'


module Antrapol
  module ToolRack
    include ConditionUtils

    class Error < StandardError; end
    # Your code goes here...
    #
    def self.logger(tag = nil, &block)
      if @_logger.nil?
        trLogout = ENV["TR_LOGOUT"]
        if not_empty?(trLogout)
          @_logger = TeLogger::Tlogger.new(trLogout, 5, 5*1024*1024)
        else
          @_logger = TeLogger::Tlogger.new('toolrack.log', 5, 5*1024*1024)
        end
      end

      if block
        if not_empty?(tag)
          @_logger.with_tag(tag, &block)
        else
          @_logger.with_tag(@_logger.tag, &block)
        end
      else
        if is_empty?(tag)
          @_logger.tag = :tr
          @_logger
        else
          # no block but tag is given? hmm
          @_logger.tag = tag
          @_logger
        end
      end

    end

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
TR::DCUtils = TR::DataConvUtils

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

TR::TerminalUtils = ToolRack::TerminalUtils

TR::ArgUtils = ToolRack::ArgUtils

