
require_relative '../lib/toolrack'

RSpec.describe TR::NullOut do

  it 'prints nothing and reads nothing' do
  
    out = TR::NullOut.new
    out.write("testing")
    out.puts "whatever"

  end

end
