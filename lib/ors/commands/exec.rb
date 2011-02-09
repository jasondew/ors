module ORS::Commands

  class Exec < Base

    def execute
      info "executing command for #{name} #{environment}..."

      execute_command migration_server, %(source ~/.rvm/scripts/rvm),
                                        %(cd #{deploy_directory}),
                                        %(bundle exec #{ENV["COMMAND"]})
    end

  end

end
