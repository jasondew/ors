module ORS::Commands

  class Update < Base

    def execute
      info "updating #{name} #{environment}..."

      execute_in_parallel(all_servers) {|server| update_code server }
      execute_in_parallel(ruby_servers) {|server| bundle_install server }

      execute_command cron_server, %(source ~/.rvm/scripts/rvm),
                                   %(cd #{deploy_directory}),
                                   %(if [ -f config/schedule.rb ]; then bundle exec whenever; fi)
    end

  end

end
