
require 'toolrack'
require_relative '../lib/toolrack'

class Config
  include TR::HashConfig
end

RSpec.describe "Hash Config" do

  it 'get set string key-value without error' do
    
    c = Config.new
    c.hcset("test.first.level", "testing")
    expect(c.hcinclude?("test.first.level")).to be true
    expect(c.hcget("test.first.level") == "testing").to be true
    expect(c.hcget("test.first.whavber").nil?).to be true

    c.hcset("test.second", { ano: :join })
    expect(c.hcinclude?("test.second")).to be true
    expect(c.hcget("test.second") == { ano: :join }).to be true

    c.hcset("test.second.hunter jack","what?")
    expect(c.hcinclude?("test.second.hunter jack")).to be true

    c.hcset("test.sequences", [1,2,3])
    expect(c.hcinclude?("test.sequences")).to be true
    expect(c.hcget("test.sequences") == [1,2,3]).to be true

  end

  it 'get set symbol key-value without error' do
    
    c = Config.new
    c.hcset([:test, :first], "testing")
    expect(c.hcinclude?([:test, :first])).to be true
    expect(c.hcget(:test) == { first: "testing" }).to be true
    expect(c.hcget(:first).nil?).to be true

    c.hcset :sec, "testing"
    expect(c.hcinclude?(:sec)).to be true
    p c

  end

  it 'returns default value if the key is nil' do
    
    c = Config.new
    expect(c.hcget("non.existance", 10) == 10).to be true

  end


end
