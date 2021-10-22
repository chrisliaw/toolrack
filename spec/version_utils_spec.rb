
require_relative '../lib/toolrack'

class Ver
  include TR::VUtils
end

RSpec.describe TR::VerUtils do

  it 'extrapolate possible versions' do
    v = Ver.new
    p v.possible_versions("0.0.0")
    p v.possible_versions("1")
    p v.possible_versions("0.1.0")
    p v.possible_versions("0.0.1")
    p v.possible_versions("0.2.1.0")
  end


end
