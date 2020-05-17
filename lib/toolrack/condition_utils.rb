

module Antrapol
  module MyToolRack
    module ConditionUtils

      def is_empty?(obj)
        if obj.nil?
          true
        elsif obj.respond_to?(:empty?)
          obj.empty?
        else
          false
        end
      end # is_empty?

      def not_empty?(obj)
        !is_empty?(obj)
      end # not empty

    end # ConditionUtils
  end # MyToolRack
end # Antrapol
