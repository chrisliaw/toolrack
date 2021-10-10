


module Antrapol
  module ToolRack
    module HashConfig
      include ConditionUtils

      class HashConfigError < StandardError; end
     
      def hcdeli=(deli)
        @hcdeli = deli
      end
      def hcdeli
        if is_empty?(@hcdeli)
          @hcdeli = "."
        end
        @hcdeli
      end

      def hcset(key, value)
        raise HashConfigError, "Nil key is not supported" if is_empty?(key)

        keys = transform_keys(key)
        root = hcConf
        keys.each do |k|
          if root.is_a?(Hash)
            if not root.keys.include?(k)
              root[k] = { }
            end

            if k == keys[-1]
              root[k] = value
            else
              root = root[k]
            end
          
          else
            raise HashConfigError, "The key '#{k}' currently not tie to a hash. It is an #{root.class} object of value '#{root}'. There is no way to add another value to key '#{key}'. Try to change it to Hash object instead." 
          end
        end
        root
      end

      def hcget(key, defVal = nil)
        if key.nil?
          return nil
        else
          keys = transform_keys(key)
          node = hcConf
          keys.each do |k|
            if node.keys.include?(k)
              node = node[k] 
            else
              node = nil
              break
            end
          end
          node.nil? ? defVal : node
        end
      end

      def hcinclude?(key)
        if key.nil?
          return false
        else
          keys = transform_keys(key) 
          node = hcConf 
          keys.each do |k|
            if node.is_a?(Hash)
              if node.keys.include?(k)
                node = node[k]
              else
                node = nil
                break
              end
            else
              node = nil
            end
          end
          not node.nil?
        end
      end

      private
      def split_key(key)
        if not_empty?(key)
          key.split(hcdeli)
        else
          [key]
        end
      end

      def transform_keys(key)
        case key
        when String
          split_key(key)
        when Array
          key
        else
          [key]
        end
      end

      def hcConf
        if @hcConf.nil?
          @hcConf = { }
        end
        @hcConf
      end

    end
  end
end

