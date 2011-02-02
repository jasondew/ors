module ORS::Commands

  class Deploy < Base

    def execute
      info "deploying #{name} #{environment}..."

      [Update, Migrate, Restart].each {|command| run command }
    end

  end

end

__END__

  def start
    info "starting #{name} #{environment}..."

    execute_in_parallel(ORS::Config.app_servers) {|server| start_server server }
  end

  def stop
    info "stopping #{name} #{environment}..."

    execute_in_parallel(ORS::Config.app_servers) {|server| stop_server server }
  end

  def restart
    info "restarting #{name} #{environment}..."

    execute_in_parallel(ORS::Config.app_servers) {|server| restart_server server }
  end

  def migrate
    info "migrating #{name} #{environment}..."

    run_migrations ORS::Config.migration_server
  end

  def setup
    info "setting up #{name} #{environment}..."

    execute_in_parallel(ORS::Config.all_servers) {|server| setup_repo server }
    execute_in_parallel(ORS::Config.ruby_servers) {|server| setup_ruby server }

    remote_execute ORS::Config.migration_server, %(source ~/.rvm/scripts/rvm),
                                                 %(cd #{deploy_directory}),
                                                 %(RAILS_ENV=#{environment} rake db:create)
  end

  def update
    info "updating #{name} #{environment}..."

    execute_in_parallel(ORS::Config.all_servers) {|server| update_code server }
    execute_in_parallel(ORS::Config.ruby_servers) {|server| bundle_install server }
  end

  private

  def setup_repo server
    info "[#{server}] installing codebase..."

    remote_execute server, %(cd #{ORS:Config.base_path}),
                           %(rm -rf #{deploy_directory}),
                           %(git clone #{REPO}:#{name} #{deploy_directory}),
                           %(mkdir -p #{deploy_directory}/tmp/pids),
                           %(mkdir -p #{deploy_directory}/log)
  end

  def setup_ruby server
    info "[#{server}] installing ruby and gems..."

    remote_execute server, %(source ~/.rvm/scripts/rvm),
                           %(cd #{deploy_directory}),
                           %(gem install rubygems-update),
                           %(gem update --system),
                           %(gem install bundler),
                           %(bundle install --without development test osx > bundler.log)
  end

  def update_code server
    info "[#{server}] updating codebase..."

    remote_execute server, %(cd #{deploy_directory}),
                           %(git fetch),
                           %(git checkout -q -f origin/#{environment}),
                           %(git reset --hard)
  end

  def bundle_install server
    info "[#{server}] installing bundle..."

    remote_execute server, %(source ~/.rvm/scripts/rvm),
                           %(cd #{deploy_directory}),
                           %(bundle install --without development test osx > bundler.log)
  end

  def start_server server
    info "[#{server}] starting unicorn..."

    remote_execute server, %(source ~/.rvm/scripts/rvm),
                           %(cd #{deploy_directory}),
                           %(bundle exec #{unicorn} -c config/unicorn.rb -D -E #{environment})
  end

  def stop_server server
    info "[#{server}] stopping unicorn..."

    remote_execute server, %(cd #{deploy_directory}),
                           %(kill \\`cat tmp/pids/unicorn.pid\\`)
  end

  def restart_server server
    info "[#{server}] restarting unicorn..."

    remote_execute server, %(cd #{deploy_directory}),
                           %(kill -USR2 \\`cat tmp/pids/unicorn.pid\\`)
  end

  def run_migrations server
    info "[#{server}] running migrations..."

    remote_execute server, %(cd #{deploy_directory}),
                           %(RAILS_ENV=#{environment} rake db:migrate db:seed)
  end

end
