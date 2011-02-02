module ORS::Commands

  class Setup < Base

    def execute
      info "setting up #{name} #{environment}..."

      execute_in_parallel(all_servers) {|server| setup_repo server }
      execute_in_parallel(ruby_servers) {|server| setup_ruby server }

      remote_execute migration_server, %(source ~/.rvm/scripts/rvm),
                                       %(cd #{deploy_directory}),
                                       %(RAILS_ENV=#{environment} rake db:create)
    end

  end

end
