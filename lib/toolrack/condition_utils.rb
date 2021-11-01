

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
        elsif obj.respond_to?(:length)
          obj.length == 0
        elsif obj.respond_to?(:size)
          obj.size == 0
        else
          false
        end
      end # is_empty?

      def not_empty?(obj)
        !is_empty?(obj)
      end # not empty

      def is_boolean?(val)
        !!val == val
      end
      alias_method :is_bool?, :is_boolean?

      def is_string_boolean?(str)
        if not_empty?(str)
          s = str.to_s.strip.downcase
          case s
          when "true", "false"
            true
          else
            false
          end
        else
          false
        end
      end
      alias_method :is_str_bool?, :is_string_boolean?

      # 
      # Make it available at class level too
      #
      def self.included(klass)
        klass.class_eval <<-END
          extend Antrapol::ToolRack::ConditionUtils
        END
      end

    end # ConditionUtils
  end # MyToolRack
end # Antrapol
