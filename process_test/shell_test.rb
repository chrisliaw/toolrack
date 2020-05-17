

require 'shell'

Shell.def_system_command(:sshKeygen,'/usr/bin/ssh-keygen')
s = Shell.new

th = Thread.new($stdout) do |out|
  
  p sshKeygen("-t","ed25519","-a","188","-o","-f","test.ssh","-C","chrisliaw@antrapol.com")

end


