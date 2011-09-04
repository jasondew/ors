module ORS::Commands

  class Update < Base

    def execute
      info "updating #{name} #{environment}..."

      execute_in_parallel(all_servers) {|server| update_code server }
      execute_in_parallel(ruby_servers) {|server| bundle_install server }

      execute_command cron_server, prepare_environment,
                                   %(if [ -f config/schedule.rb ]; then bundle exec whenever --update-crontab --set environment=#{environment} -i #{name}_#{environment}; fi)
    end

  end

end
