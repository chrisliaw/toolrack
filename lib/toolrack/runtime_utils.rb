

module Antrapol
  module ToolRack
    module RuntimeUtils

      def RuntimeUtils.on_windows?
        (RbConfig::CONFIG['host_os'] =~ /cygwin|mswin|mingw|bccwin|wince|emx/) != nil
      end

      def RuntimeUtils.on_mac?
        (RbConfig::CONFIG['host_os'] =~ /darwin|mac/) != nil
      end

      def RuntimeUtils.on_linux?
        (RbConfig::CONFIG['host_os'] =~ /linux/) != nil
      end

      def RuntimeUtils.os_string
        RbConfig::CONFIG['host_os']
      end

      def RuntimeUtils.on_ruby?
        not on_jruby? 
      end

      def RuntimeUtils.on_jruby?
        (RUBY_PLATFORM =~ /java/) != nil
      end

      class <<self
        alias_method :on_java?, :on_jruby?
      end

    end # RuntimeUtils
  end # ToolRack
end #Antrapol
