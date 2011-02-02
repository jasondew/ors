module ORS
  module Commands

    def help
      puts <<-END
Usage: ./ors <action> [environment=production] [options]

=== Actions
help          You're looking at it
console       Bring up a console on the production servers
logs          Show the last few log entries from the production servers
deploy        Update the code, run the migrations, and restart unicorn
setup         Sets up the default environment on the servers
update        Updates the code on all servers
start         Starts up unicorn on the app servers
stop          Stops unicorn on the app servers
restart       Retarts unicorn on the app servers

=== Environments
Must be one of: production demo staging
Defaults to production.

=== Options
--pretend    (or -p)   Don't execute anything, just show me what you're going to do
--no-gateway (or -ng)  Don't use a gateway (if you're inside the firewall)
      END
    end

  end
end
