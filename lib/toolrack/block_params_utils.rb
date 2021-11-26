


module Antrapol
  module ToolRack
    module BlockParamsUtils
      include ConditionUtils

      def value_from_block(blockKey, defValue, opts = { }, &block)
        if block
          blockParams = nil
          if not_empty?(opts)
            blockParams = opts[:blockArgs]
          end

          value = nil
          if blockParams.nil?
            value = block.call(blockKey)
            value = defValue if is_empty?(value) 
          else
            value = block.call(blockKey, *blockParams)
            value = defValue if is_empty?(value)
          end

          value
        else
          defValue
        end
      end


      def self.included(klass)
        klass.class_eval <<-END
          extend Antrapol::ToolRack::BlockParamsUtils
        END
      end

    end
  end
end
