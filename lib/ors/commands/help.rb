module ORS::Commands

  class Help < Base

    def execute
      puts <<-END
Usage: ./ors <action> [environment=production] [options]

=== Actions
changes       View changes between what is deployed and committed
check         Prints out contents of restart.timestamp on the app servers
console       Bring up a console on the console server
deploy        Update the code, run the migrations, and restart puma
help          You're looking at it
logs          Show the last few log entries from the production servers
migrate       Runs the migrations on the migration server
restart       Retarts puma on the app servers
runner        Runs ruby code via Rails' runner on the console server
setup         Sets up the default environment on the servers
start         Starts up puma on the app servers
stop          Stops puma on the app servers
update        Updates the code on all servers

=== Environments
Must be one of: production demo staging
Defaults to production.

=== Options
--pretend    (or -p)   Don't execute anything, just show me what you're going to do (default: false)
--no-gateway (or -ng)  Don't use a gateway (if you're inside the firewall)          (default: true)
      END
    end

  end
end
