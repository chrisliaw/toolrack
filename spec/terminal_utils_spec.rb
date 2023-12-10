require_relative '../lib/toolrack/terminal_utils'

RSpec.describe 'Terminal Utils' do
  it 'spawn a terminal and run command in it' do
    class Driver
      include Antrapol::ToolRack::TerminalUtils
    end

    d = Driver.new
    # d.tu_new_terminal("terminator","ssh docean")
    d.tu_new_terminal('iTerm2', 'ssh docean')
    # d.tu_new_terminal("gnome-terminal","git status")
  end
end
