module ORS::Commands
  class Console < Base
    def execute
      execute_command(console_server,
                      true,
                      %(source ~/.rvm/scripts/rvm),
                      %(cd #{deploy_directory}),
                      %(bundle exec rails console #{environment}))
    end

    def help
      puts <<-END
Usage: ./ors console [environment=production] [options]

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
