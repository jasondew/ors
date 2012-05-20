class ORS
  module Commands
    class Help < Base

      def execute
        puts <<-END
Usage: ./ors <action> [environment=production] [options]

=== Actions
changes       View changes between what is deployed and committed
check         Prints out contents of restart.timestamp on the app servers
console       Bring up a console on the console server
deploy        Update the code, run the migrations, and restart unicorn
help          You're looking at it
logs          Show the last few log entries from the production servers
migrate       Runs the migrations on the migration server
restart       Retarts unicorn on the app servers
runner        Runs ruby code via Rails' runner on the console server
setup         Sets up the default environment on the servers
start         Starts up unicorn on the app servers
stop          Stops unicorn on the app servers
update        Updates the code on all servers

=== Environments
Must be one of: production demo staging
Defaults to production.

#{help_options}
        END
      end
    end # Help < Base
  end
end
