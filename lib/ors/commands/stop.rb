module ORS::Commands

  class Stop < Base

    def execute
      info "stopping #{name} #{environment}..."

      execute_in_parallel(app_servers) {|server| stop_server server }
    end

  end

end
