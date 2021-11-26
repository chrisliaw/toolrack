
require 'toolrack'


RSpec.describe "Test block params utils" do

  it 'facilitate value from block' do
    class Test
      include TR::BlockParamsUtils

      def run(&block)
        v = value_from_block(:first, "Default first", &block)
      end

      def complex_run(&block)
        v = value_from_block(:complex, "whatever", { blockArgs: ["jan", "anything"] }, &block)
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

    expect(t.complex_run == "whatever").to be true
    v = t.complex_run do |*opts|
      expect(opts[0] == :complex).to be true 
      expect(opts[1] == "jan").to be true 
      expect(opts[2] == "anything").to be true 

      "value from the top"
    end

    expect(v == "value from the top").to be true


  end

end
