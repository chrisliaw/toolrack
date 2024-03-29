

module Antrapol
  module ToolRack
    module ConditionUtils

      private
      def is_empty?(obj)
        if not defined?(obj)
          true
        elsif obj.nil?
          true
        elsif obj.respond_to?(:empty?)
          begin
            if obj.respond_to?(:strip)
              if obj.ascii_only?
                obj.strip.empty?
              else
                obj.empty?
              end
            else
              obj.empty?
            end
          rescue ArgumentError => ex
            # strip sometimes trigger 'invalid byte sequence in UTF-8' error
            # This will happen if the data is binary but the reading of the data
            # is in ascii format. 
            if ex.message =~ /invalid byte sequence/
              cuLogger.twarn :is_empty?, "Invalid byte sequence exception indicates the data is in binary but was given a ASCII buffer to test."
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
        not_empty?(val) and (!!val == val)
      end
      def is_bool?(val)
        is_boolean?(val)
      end
      #alias_method :is_bool?, :is_boolean?

      def not_boolean?(val)
        not is_boolean?(val)
      end
      def not_bool?(val)
        not_boolean?(val)
      end
      #alias_method :not_bool?, :not_boolean?

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
      #alias_method :is_str_bool?, :is_string_boolean?
      def is_str_bool?(str)
        is_string_boolean?(str)
      end

      def cuLogger
        if @cuLogger.nil?
          @cuLogger = Tlogger.new
        end
        @cuLogger
      end


      # Superceded by module_function directive?
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
