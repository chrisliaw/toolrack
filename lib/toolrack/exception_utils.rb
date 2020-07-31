
require_relative 'condition_utils'

module Antrapol
  module ToolRack
    module ExceptionUtils
      include Antrapol::ToolRack::ConditionUtils

      # raise_if_empty
      # Raise the given (or default if not given) exception if the val given is empty
      # val - variable/object that shall be tested for emptiness
      # message - message to be thrown if it is true
      # error - exception object to be thrown
      def raise_if_empty(val, message, error = Antrapol::ToolRack::Error)
        raise_error(message,error) if is_empty?(val)
      end # raise_if_empty

      # 
      # raise_if_false
      #
      def raise_if_false(bool, message, error = Antrapol::ToolRack::Error)
        if not bool
          raise_error(message,error)
        end 
      end # raise_if_false

      #
      # raise_if_true
      #
      def raise_if_true(bool, message, error = Antrapol::ToolRack::Error)
        raise_if_false(!bool, message, error)
      end # raise_if_true

      protected
      def raise_error(message, error = Antrapol::ToolRack::Error)
        if error.nil?
          if @default_exception.nil?
            raise Antrapol::ToolRack::Error, message
          else
            raise @default_exception, message
          end
        else
          raise error, message
        end
      end # raise_error
      
    end # ExceptionUtils
  end # ToolRack
end # Antrapol
