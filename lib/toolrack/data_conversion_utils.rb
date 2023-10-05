
require 'base64'
#require 'base58'

module Antrapol
  module ToolRack
    module DataConversionUtils
      include ConditionUtils
      
      def from_b64(str)
        if not_empty?(str)
          # decode operation supports both strict or non strict output
          Base64.decode64(str)
        else
          str
        end
      end

      def to_b64(bin)
        if not_empty?(bin)
          # Base64 standard output which has new line in the middle of the output
          Base64.encode64(bin)
        else
          bin
        end
      end

      def to_b64_strict(bin)
        if not_empty?(bin)
          # strict base64 shall have NO new line in the middle of the output
          Base64.strict_encode64(bin)
        else
          bin
        end
      end

      def from_b64_strict(str)
        if not_empty?(str)
          Base64.strict_decode64(str)
        else
          str
        end
      end

      #def to_b58(val)
      #  return "" if is_empty?(val)

      #  case val
      #  when Integer
      #    Base58.int_to_base58(val)
      #  else
      #    Base58.binary_to_base58(val.force_encoding('BINARY'))
      #  end
      #end

      #def from_b58(str)
      #  return "" if is_empty?(str)
      #  Base58.base58_to_binary(str) 
      #end

      #def b58_to_number(str)
      #  return 0 if is_empty?(str)
      #  Base58.base58_to_int(str)
      #end

      def from_hex(str)
        if not_empty?(str)
          str.scan(/../).map { |x| x.hex.chr }.join
        else
          str
        end
      end
      alias_method :from_hex_string, :from_hex

      def hex_to_number(str)
        if not_empty?(str)
          str.to_i(16)
        else
          str
        end
      end
      alias_method :hex_to_num, :hex_to_number
      alias_method :hex_to_int, :hex_to_number

      def to_hex(bin)
        if not_empty?(bin) 
          case bin
          when String
            bin.each_byte.map { |b| b.to_s(16).rjust(2,'0') }.join
          when Integer
            bin.to_s(16)
          else
            bin
          end
        else
          bin
        end
      end

      def hex_to_bin(hex)
        if not_empty?(hex)
          # [abcd1234].pack('H*')
          # turn hex to binary
          case hex
          when Array
            hex.pack('H*')
          else 
            hex.split.pack('H*')
          end
        else
          hex
        end
      end

      def bin_to_int(bin)
        if not_empty?(bin)
          bin.bytes.inject { |a,b| (a << 8) + b }
        else
          bin
        end
      end

      def int_to_bin(intStr)
        if not_empty?(intStr)
          hex_to_bin(intStr.to_i.to_s(16))
        else
          intStr
        end
      end

      def string_to_bool(str)
        if not_empty?(str) and is_str_bool?(str)
          s = str.to_s.strip.downcase
          case s
          when "true"
            true
          when "false"
            false
          else
            nil
          end
        else
          nil
        end
      end
      alias_method :str_to_bool, :string_to_bool
      alias_method :string_to_boolean, :string_to_bool



      # 
      # Make it available at class level too
      #
      def self.included(klass)
        klass.class_eval <<-END
          extend Antrapol::ToolRack::DataConversionUtils
        END
      end


    end
  end
end
