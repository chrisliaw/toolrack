

module Antrapol
  module ToolRack
    module ConditionUtils

      def is_empty?(obj)
        if not defined?(obj)
          true
        elsif obj.nil?
          true
        elsif obj.respond_to?(:empty?)
          begin
            if obj.respond_to?(:strip)
              obj.strip.empty?
            else
              obj.empty?
            end
          rescue ArgumentError => ex
            # strip sometimes trigger 'invalid byte sequence in UTF-8' error
            # This will happen if the data is binary but the reading of the data
            # is in ascii format. 
            if ex =~ /invalid byte sequence/
              cuLogger.odebug :is_empty?, "Invalid byte sequence exception might indicates the data is expected in binary but was given a ASCII buffer to test"
              false
            else
              raise
            end
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

      def cuLogger
        if @cuLogger.nil?
          @cuLogger = Tlogger.new
        end
        @cuLogger
      end

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
