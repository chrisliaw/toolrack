
require 'toolrack'
require 'tempfile'

include ToolRack::ConditionUtils

RSpec.describe "ToolRack ConditionUtils" do

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

end
