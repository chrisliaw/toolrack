require_relative "test_helper"

require 'toolrack'

class ToolrackTest < Minitest::Test
  def test_that_it_has_a_version_number
    refute_nil Antrapol::ToolRack::VERSION
    refute_nil ToolRack::VERSION
  end

  #def test_pty
  #  Antrapol::ToolRack::ProcessUtilsEngine.pty_exec(["ssh-keygen","-t","ed25519","-a","188","-o","-f","test.ssh","-C","chrisliaw@antrapol.com"]) do |ops, val|
  #    p val
  #    print val[:data].join
  #  end
  #end

  def test_basic
    p Antrapol::ToolRack::ProcessUtilsEngine.exec("sudo apt update")
  end

end
