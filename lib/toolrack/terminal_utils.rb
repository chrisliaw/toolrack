
require_relative 'runtime_utils'

module Antrapol
  module ToolRack
    
    class TerminalUtilsException < StandardError; end

    module TerminalUtils
     
      def tu_new_terminal(terminal, cmd)

        cmd = [cmd] if not cmd.is_a?(Array)

        case terminal
        when "terminator", "tilix"
          #`#{terminal} -x "#{cmd.join(" ")}"`
          `#{terminal} -e "bash -c '#{cmd.join(" ")}'" &`

        when "gnome-terminal"
          `#{terminal} -- bash -c "#{cmd.join(" ")}; exec bash"`

        when "iTerm2"
          `osascript -e \
               'tell application "iTerm"
               activate

               create window with default profile
               delay 0.5

               set currentWindow to current window

               tell current session of currentWindow
               write text "#{cmd.join(" ")}"
               end tell

               end tell'
          `
        when "Terminal" 
          `osascript -e \
               'tell application "Terminal"
               activate
               do script "#{cmd.join(" ")}"
               end tell'
          `

        else
          raise TerminalUtilsException, "Terminal '#{terminal}' not supported. Supported terminal are : #{tu_possible_terminal.join(", ")}" 
        end

      end

      def tu_possible_terminal
        avail = []
        if RuntimeUtils.on_linux?
          possible = [ "gnome-terminal","konsole","tilix", "terminator" ]
          possible.each do |app|
            avail << app if not File.which(app).nil?
          end
        elsif RuntimeUtils.on_windows?
          avail << "cmd.exe"
        elsif RuntimeUtils.on_mac?
          avail << "Terminal"
          avail << "iTerm2"
        end
        avail
      end # tu_possible_terminal

    end
  end
end
