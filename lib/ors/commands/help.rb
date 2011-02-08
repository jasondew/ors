module ORS::Commands

  class Help < Base

    def execute
      puts <<-END
Usage: ./ors <action> [environment=production] [options]

=== Actions
help          You're looking at it
console       Bring up a console on the production servers
logs          Show the last few log entries from the production servers
deploy        Update the code, run the migrations, and restart unicorn
setup         Sets up the default environment on the servers
update        Updates the code on all servers
migrate       Runs the migrations on the migration server
start         Starts up unicorn on the app servers
stop          Stops unicorn on the app servers
restart       Retarts unicorn on the app servers

=== Environments
Must be one of: production demo staging
Defaults to production.

=== Options
--pretend    (or -p)   Don't execute anything, just show me what you're going to do (default: false)
--no-gateway (or -ng)  Don't use a gateway (if you're inside the firewall)          (default: true)
--rails-2    (or -r2)  Rails 2 application (use unicorn_rails instead of unicorn)
      END
    end

  end
end
