
require_relative '../lib/toolrack'

class CliUtils
  include ToolRack::CliUtils
end

RSpec.describe ToolRack::CliUtils do

  it 'find out what is the full path to an executable' do
  
    path = CliUtils.which('bash')
    expect(path).not_to be_nil

    expect(CliUtils.which('ruby')).not_to be_nil

  end


end
