
require 'toolrack'

include ToolRack::PassUtils

RSpec.describe ToolRack::PassUtils do

  it 'generates random password' do
    out = gen_rand_pass 
    expect(out).not_to be_nil
    expect(out.length == 12).to be true

    out = gen_rand_pass(24)
    expect(out).not_to be_nil
    expect(out.length == 24).to be true

    out = gen_rand_pass(nil)
    expect(out).not_to be_nil
    expect(out.length == 12).to be true

  end

end
