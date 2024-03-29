
require 'toolrack'
require 'tempfile'

#include ToolRack::ConditionUtils

describe "ToolRack ConditionUtils" do
  
  include ToolRack::ConditionUtils

  it 'detect empty of not empty' do
    
    expect(is_empty?(@anyting)).to be true
    @eString = ""
    expect(is_empty?(@eString)).to be true
    expect(not_empty?(@eString)).to be false

    i = 0
    expect(is_empty?(i)).to be false
    expect(is_empty?(StringIO.new)).to be true

    Tempfile.open do |f|
      expect(is_empty?(f)).to be true
      f.write "testing"
      expect(is_empty?(f)).to be false
      f.truncate(0)
      expect(is_empty?(f)).to be true
    end

  end

  it 'detects if give value is a boolean or not' do

    expect(is_bool?(true)).to be true
    expect(is_bool?(false)).to be true

    t = true
    expect(is_bool?(t)).to be true
    expect(is_bool?(!t)).to be true

    tt = "true"
    expect(is_bool?(tt)).to be false
    expect(is_bool?(!tt)).to be true
  end

  it 'includes into target class and created instance and class level methods' do
    
    class Driver
      include ToolRack::ConditionUtils

      def self.check
        is_empty?("") and not_empty?("test") and is_bool?(true) and is_str_bool?("true")
      end

      def check
        respond_to?(:is_empty?, true) and respond_to?(:not_empty?, true)  and respond_to?(:is_bool?, true)   and respond_to?(:is_str_bool?, true)
      end

    end

    expect(Driver.check).to be true

    expect {
      Driver.is_empty?("")
    }.to raise_exception(NoMethodError)
 
    d = Driver.new
    expect(d.check).to be true
    expect {
      d.is_empty?("")
    }.to raise_exception(NoMethodError)


  end

end
