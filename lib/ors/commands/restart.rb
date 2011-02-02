module ORS::Commands

  class Restart < Base

    def execute
      info "restarting #{name} #{environment}..."

      execute_in_parallel(app_servers) {|server| restart_server server }
    end

  end

end
