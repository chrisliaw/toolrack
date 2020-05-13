

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

    end # ConditionUtils
  end # MyToolRack
end # Antrapol
