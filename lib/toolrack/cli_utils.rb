

module Antrapol
  module ToolRack
    module CliUtils
      include Antrapol::ToolRack::ConditionUtils 

      class CliUtilsError < StandardError; end

      def which(app)
        if not_empty?(app)
          path = `which #{app}` 
          path.strip if not_empty?(path)
        else
          raise CliUtilsError, "Given appication to look for full path (which) is empty"
        end
      end


      def self.included(klass)
        klass.class_eval <<-END
        extend Antrapol::ToolRack::CliUtils
        END
      end

    end
  end
end
