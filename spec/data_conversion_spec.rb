

require 'toolrack'
require 'securerandom'

include TR::DataConvUtils

RSpec.describe "ToolRack Data Conversion Utils" do

  it 'converts binary to base64 and convert it back' do
    
    bin = SecureRandom.random_bytes(1024)
    b64 = to_b64(bin)
    sb64 = to_b64_strict(bin)

    expect((b64 =~ /\n/) != nil).to be true
    expect((sb64 =~ /\n/) != nil).to be false

    expect(from_b64(b64) == bin).to be true
    expect(from_b64(sb64) == bin).to be true

  end

  it 'converts binary to hex and convert it back' do
    
    bin = SecureRandom.random_bytes(1024)
    hex = to_hex(bin)

    expect(hex.length == 1024*2).to be true
    expect(from_hex(hex) == bin).to be true

    i = 1024
    hi = to_hex(i)

    expect(hex_to_num(hi) == i).to be true

  end

  it 'converts to Base58 and conver it back' do
    
    bin = SecureRandom.random_bytes(1024)
    b58 = to_b58(bin)

    p b58
    expect(b58).not_to be_nil
    expect(b58.length > 0).to be true

    rbin = from_b58(b58)
    expect(rbin == bin).to be true

  end


end
