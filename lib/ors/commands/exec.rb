module ORS::Commands

  class Exec < Base

    def execute
      info "executing command for #{name} #{environment}..."

      execute_command migration_server, prepare_environment, %(bundle exec #{ENV["CMD"]})
    end

  end

end
