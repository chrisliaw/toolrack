
require 'toolrack'

RSpec.describe TR::MixinHelper do

  it 'describe the issue' do
    module First
      module ClassMethods
        def first_say
          "first say"
        end

        def first_say_again
          "first_say_again"
        end
      end
      # triggered when other modules/classes has 'include First'
      def self.included(klass)
        klass.extend(ClassMethods)
      end

      # expose the class methods on First module too
      self.extend(ClassMethods)
    end

    # power of self.extend(ClassMethods)
    expect(First.respond_to?(:first_say)).to be true
    expect(First.respond_to?(:first_say_again)).to be true

    module Second
      include First
    end

    expect(Second.respond_to?(:first_say)).to be true
    expect(Second.respond_to?(:first_say_again)).to be true

    # ...  so far so good
    module Third
      include Second
    end

    # This is the problem...
    # In order for Third to get class method of First, it has to be properly exported out from Second
    # But in actual dev, module is very likely externa libraries... the module at the leaves of the structure
    # might not have idea what's being exported out from module before it
    expect(Third.respond_to?(:first_say)).to be false

    # one viable way to do that is
    module Second
      include First
      module ClassMethods
        # have to chain up the ClassMethod from included module
        include First::ClassMethods
      end
      def self.included(klass)
        klass.extend(ClassMethods)
      end
      self.extend(ClassMethods)
    end
    module Third
      include Second
    end
    # Now after the modication at module Second which exports the ClassMethods from First
    # Only then module Third could have visiblity of the class methods from First
    expect(Third.respond_to?(:first_say)).to be true

    # Note those method to export the ClassMethods are the same
    # Therefore the TR::MixinHelper is the one that automate those code
    # This is not one-size-fit-all solution however.
    # Use this MixinHelper to
    # * Expect class methods from included library to be automated available on included module/class
    # If you would like to hide the methods to be used by other use the existing ruby cosntruct

  end

  it 'expose class methods automatically' do
    module First
      include TR::MixinHelper
      class_method do
        def first_say
          "first say"
        end

        def first_say_again
          "first_say_again"
        end
      end
    end

    module Second
      include TR::MixinHelper
      mixin(First)

      class_method do
        def second_say
          "second say"
        end
      end

      def second_inst_say
        "Second instance say"
      end
    end
    expect(Second.respond_to?(:first_say)).to be true
    expect(Second.respond_to?(:first_say_again)).to be true

    class SecondFinal
      include TR::MixinHelper
      mixin(Second)
    end

    expect(SecondFinal.respond_to?(:first_say)).to be true
    expect(SecondFinal.respond_to?(:first_say_again)).to be true
    sf = SecondFinal.new
    expect(sf.respond_to?(:second_inst_say)).to be true


    module Third
      include TR::MixinHelper
      mixin(Second)
    end
    expect(Third.respond_to?(:first_say)).to be true
    expect(Third.respond_to?(:first_say_again)).to be true
    expect(Third.respond_to?(:second_say)).to be true

    class ThirdFinal
      include TR::MixinHelper
      mixin(Third)
    end
    expect(ThirdFinal.respond_to?(:first_say)).to be true
    expect(ThirdFinal.respond_to?(:first_say_again)).to be true
    expect(ThirdFinal.respond_to?(:second_say)).to be true
    tf = ThirdFinal.new
    expect(tf.respond_to?(:second_inst_say)).to be true

    module External
      include TR::MixinHelper

      class_method do
        def external_say
          "external say"
        end
      end

      def external_int_say
        "external_int_say"
      end
    end

    class ThirdFinal2
      include TR::MixinHelper
      mixin(Third)
      mixin(External)
    end

    expect(ThirdFinal2.respond_to?(:first_say)).to be true
    expect(ThirdFinal2.respond_to?(:first_say_again)).to be true
    expect(ThirdFinal2.respond_to?(:second_say)).to be true
    expect(ThirdFinal2.respond_to?(:external_say)).to be true
    tf = ThirdFinal2.new
    expect(tf.respond_to?(:second_inst_say)).to be true
    expect(tf.respond_to?(:external_int_say)).to be true

  end

end
