

module Antrapol
  module ToolRack
    module MixinHelper

      module ClassMethods
        def mixin(cls)
          self.class_eval "include #{cls}"
        end

        def class_method(&block)
          class_eval <<-END
          module ClassMethods
          end
          END
          ClassMethods.class_eval(&block)
        end
      end # module ClassMethods

      def self.included(klass)
        klass.extend(ClassMethods)
      end
      
    end    
  end
end
