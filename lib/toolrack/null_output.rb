

module Antrapol
  module ToolRack
    class NullOutput

      def method_missing(mtd, *args, &block)
        # sink-holed all methods call
        logger.tdebug :nullOut, "#{mtd} / #{args} / #{block ? "with block" : "no block"}"
      end

      private
      def logger
        if @logger.nil?
          @logger = Tlogger.new
        end
        @logger
      end

    end
  end
end
