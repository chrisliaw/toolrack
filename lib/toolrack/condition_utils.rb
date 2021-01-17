

module Antrapol
  module ToolRack
    module ConditionUtils

      def is_empty?(obj)
        if not defined?(obj)
          true
        elsif obj.nil?
          true
        elsif obj.respond_to?(:empty?)
          if obj.respond_to?(:strip)
            obj.strip.empty?
          else
            obj.empty?
          end
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
