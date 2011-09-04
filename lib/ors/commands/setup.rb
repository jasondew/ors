module ORS::Commands

  class Setup < Base

    def execute
      info "setting up #{name} #{environment}..."

      info "Are you sure? ('yes' + ctrl+D^2)"
      if STDIN.read == "yes"
        execute_in_parallel(all_servers) {|server| setup_repo server }
        execute_in_parallel(ruby_servers) {|server| setup_ruby server }

        execute_command migration_server, prepare_environment,
                                          %(RAILS_ENV=#{environment} bundle exec rake db:create)
      else
        info "Setup aborted."
      end
    end

  end

end
