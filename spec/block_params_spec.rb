
require 'toolrack'


RSpec.describe "Test block params utils" do

  it 'facilitate value from block' do
    class Test
      include TR::BlockParamsUtils

      def run(&block)
        v = value_from_block(:first, "Default first", &block)
      end

      def run_with_args(&block)
        v = value_from_block(:complex, "whatever", { blockArgs: ["jan", "anything"] }, &block)
      end

      def intercept_run(&block)
        v = value_from_block(:threshold_met, "default threshold") do |*args|
          key = args.first
          case key
          when :inspect_given_value
            v = args.last
            if v == "overflow"
              raise StandardError, "Exception raised!"
            end
          else
            block.call(*args) if block
          end
        end
      end
    end

    t = Test.new
    expect(t.run == "Default first").to be true
    v = t.run do |opts|
      case opts
      when :first
        "Ah ha... first"
      end
    end
    expect(v == "Ah ha... first").to be true

    expect(t.run_with_args == "whatever").to be true
    v = t.run_with_args do |*opts|
      if opts[0] == :complex
        expect(opts[1] == "jan").to be true 
        expect(opts[2] == "anything").to be true 
      end

      "value from the top"
    end

    expect(v == "value from the top").to be true

    expect(t.intercept_run == "default threshold").to be true
    expect {
      t.intercept_run do |*opts|
        key = opts.first
        case key
        when :threshold_met
          "overflow"
        end
      end 
    }.to raise_exception(StandardError)

    v = t.intercept_run do |*opts|
      key = opts.first
      case key
      when :threshold_met
        "within limit"
      end
    end 
    expect(v == "within limit").to be true

  end

end
