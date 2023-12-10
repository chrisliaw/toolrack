require_relative 'runtime_utils'

module Antrapol
  module ToolRack
    class TerminalUtilsException < StandardError; end

    module TerminalUtils
      def tu_new_terminal(terminal, cmd)
        cmd = [cmd] unless cmd.is_a?(Array)

        case terminal
        when 'terminator'
          ToolRack.logger("termutils").debug "Command to be run in terminal '#{terminal}' : #{cmd.join(" ")}"
          `#{terminal} -x "#{cmd.join(' ')}"`

        when 'gnome-terminal'
          ToolRack.logger("termutils").debug "Command to be run in terminal '#{terminal}' : #{cmd.join(" ")}"
          `#{terminal} -- bash -c "#{cmd.join(' ')}; exec bash"`

        when 'iTerm2'
         
          ToolRack.logger("termutils").debug "Command to be run in terminal '#{terminal}' : #{cmd.join(" ").gsub("\"","\\\"")}"

          `osascript -e \
            'tell application "iTerm"
            activate

            create window with default profile
            delay 0.5

            set currentWindow to current window

            tell current session of currentWindow
              write text "#{cmd.join(' ').gsub("\"","\\\"")}"
            end tell

            end tell'
          `
        when 'Terminal'
          
          ToolRack.logger("termutils").debug "Command to be run in terminal '#{terminal}' : #{cmd.join(" ").gsub("\"","\\\"")}"

          `osascript -e \
               'tell application "Terminal"
               activate
               do script "#{cmd.join(' ').gsub("\"","\\\"")}"
               end tell'
          `

        else
          raise TerminalUtilsException,
                "Terminal '#{terminal}' not supported. Supported terminal are : #{tu.possible_terminal.join(', ')}"
        end
      end

      def tu_possible_terminal
        avail = []
        if RuntimeUtils.on_linux?
          possible = %w[gnome-terminal konsole tilix terminator]
          possible.each do |app|
            avail << app unless File.which(app).nil?
          end
        elsif RuntimeUtils.on_windows?
          avail << 'cmd.exe'
        elsif RuntimeUtils.on_mac?
          avail << 'Terminal'
          avail << 'iTerm2'
        end
        avail
      end # tu_possible_terminal
    end
  end
end
