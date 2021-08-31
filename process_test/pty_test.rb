


require 'pty'
require 'expect'

#m, s = PTY.open
#r, w = IO.pipe
#
#pid = spawn("/usr/bin/openvpn --config /home/chris/.openvpn_cli/sg2-ovpn-tcp.ovpn", in: r, out: s)
#r.close
#s.close
#
#
#ret = begin
#        p m.gets
#      rescue Errno::EIO
#        nil
#      end
#


##PTY.spawn("/usr/bin/sudo /usr/bin/openvpn --config /home/chris/.openvpn_cli/sg2-ovpn-tcp.ovpn") do |read, write, pid|
#PTY.spawn("/usr/bin/openvpn --config /home/chris/.openvpn_cli/sg2-ovpn-tcp.ovpn") do |read, write, pid|
#  #read.expect(/\[sudo\] password for chris:/) { |m|
#  #  p m
#  #  puts "expect"
#  #  write.printf("chr1st0pher1120\n")
#  #}
#  #read.expect(/Username:/) { |msg| 
#  #  puts "-- #{msg}"
#  #  write.printf("purevpn0s2643230\r\n") 
#  #}
#
#  #read.expect(/no echo\)/) { |msg|
#  #  puts "++ #{msg}"
#  #  write.printf("\t@ntr@p0l.c0m\r\n")
#  #}
#
#  loop do
#    read.expect(/\n/) { |l| 
#      p l
#      @ln = l 
#    }
#    break if @ln.nil?
#  end
#end

read, write, pid = PTY.spawn("/usr/bin/openvpn --config /home/chris/.openvpn_cli/sg2-ovpn-tcp.ovpn")

puts "PID : #{pid}"

trap "SIGINT" do
  read.close
  write.close
  begin
    puts "Killing process"
    Process.kill("HUP",pid)
    puts "Kill done. Start waiting"
    Process.wait(pid)
    STDERR.puts "Cleanup Done!"
  rescue PTY::ChildExited
  end
end

loop do
  read.expect(/\n/) do |l|
    puts l
    @ln = l
  end
  break if @ln.nil?
end


