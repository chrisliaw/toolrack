

module Antrapol
  module MyToolRack
    module RuntimeUtils

      def detect_os
        case RbConfig::CONFIG['host_os']
        when /cygwin|mswin|mingw|bccwin|wince|emx/
          :win
        when /darwin|mac/
          :mac
        else
          :linux
        end
      end

      def detect_ruby
        
      end

    end
  end
end
