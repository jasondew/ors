module ORS::Commands

  class Start < Base

    def execute
      info "starting #{name} #{environment}..."

      execute_in_parallel(app_servers) {|server| start_server server }
    end

  end

end
