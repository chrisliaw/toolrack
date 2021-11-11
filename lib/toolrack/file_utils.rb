
require 'openssl'

module Antrapol
  module ToolRack
    module FileUtils
      include Antrapol::ToolRack::DataConversionUtils

      class FileUtilsError < StandardError; end
      module ClassMethods
        def is_same?(*args, &block)
          opts = { verbose: false } 
          if args.last.is_a?(Hash)
            opts.merge!(args.last)
            target = args[0..-2]
          else
            target = args
          end

          raise FileUtilsError, "is_same? requires at least 2 files" if target.length < 2

          res = true
          size = nil
          target.each do |f|
            raise FileUtilsError, "Given file #{f} to is_same? does not exist" if not File.exist?(f)

            if size.nil?
              size = File.size(f)
            elsif File.size(f) != size
              res = false 
              break
            end

          end

          if res
            prevDigRes = nil
            target.each do |f|
              dig = OpenSSL::Digest.new("SHA256")
              bufSize = 2048*1000
              File.open(f,"rb") do |f|
                dig.update(f.read(bufSize))
              end
              digRes = dig.digest

              STDOUT.puts "#{f} : #{to_hex(digRes)}" if opts[:verbose]

              if prevDigRes.nil?
                prevDigRes = digRes
              elsif prevDigRes != digRes 
                res = false
                break
              end
            end
          end

          res

        end
      end

      def self.included(klass)
        File.class_eval <<-END
        extend Antrapol::ToolRack::FileUtils::ClassMethods
        END
      end
      
    end
  end
end


