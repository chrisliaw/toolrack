
require 'toolrack'

include TR::FileUtils

RSpec.describe "File utils" do

  it 'adds is_same? method into File object' do

    expect(File.respond_to?(:is_same?)).to be true

    expect { File.is_same? }.to raise_exception(Antrapol::ToolRack::FileUtils::FileUtilsError)

    expect(File.is_same?('toolrack-0.3.0.gem','toolrack-0.3.0.gem')).to be true
    expect(File.is_same?('toolrack-0.3.0.gem','toolrack-0.1.0.gem')).to be false

    res = File.is_same?('toolrack-0.3.0.gem','toolrack-0.3.0.gem', { verbose: true })
    expect(res).to be true
    
  end

end
