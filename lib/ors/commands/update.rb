module ORS::Commands

  class Update < Base

    def execute
      info "updating #{name} #{environment}..."

      execute_in_parallel(all_servers) {|server| update_code server }
      execute_in_parallel(ruby_servers) {|server| bundle_install server }
    end

  end

end
