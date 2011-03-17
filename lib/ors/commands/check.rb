module ORS::Commands
  class Check < Base
    def execute
      timestamps = app_servers.map do |server|
        [
         "[#{server}]",
         execute_command(server,
                         %(cd #{deploy_directory}),
                         %(cat restart.timestamp),
                         :capture => true)
        ].join
      end.join("\n")

      puts timestamps unless pretending
    end

    def help
      puts <<-END
Usage: ./ors check [environment=production] [options]

=== Description
Prints out contents of restart.timestamp on the app servers

=== Options
--pretend    (or -p)   Don't execute anything, just show me what you're going to do
--no-gateway (or -ng)  Don't use a gateway (if you're inside the firewall)
      END
    end
  end
end
