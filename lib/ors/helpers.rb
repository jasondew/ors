module ORS
  module Helpers

    include Config

    def setup_repo server
      info "[#{server}] installing codebase..."

      execute_command server, %(cd #{base_path}),
                             %(rm -rf #{deploy_directory}),
                             %(git clone #{REPO}:#{name} #{deploy_directory}),
                             %(mkdir -p #{deploy_directory}/tmp/pids),
                             %(mkdir -p #{deploy_directory}/log)
    end

    def setup_ruby server
      info "[#{server}] installing ruby and gems..."

      execute_command server, %(source ~/.rvm/scripts/rvm),
                             %(cd #{deploy_directory}),
                             %(gem install rubygems-update),
                             %(gem update --system),
                             %(gem install bundler),
                             %(bundle install --without development test osx > bundler.log)
    end

    def update_code server
      info "[#{server}] updating codebase..."

      execute_command server, %(cd #{deploy_directory}),
                             %(git fetch),
                             %(git checkout -q -f origin/#{environment}),
                             %(git reset --hard)
    end

    def bundle_install server
      info "[#{server}] installing bundle..."

      execute_command server, %(source ~/.rvm/scripts/rvm),
                             %(cd #{deploy_directory}),
                             %(bundle install --without development test osx > bundler.log)
    end

    def start_server server
      info "[#{server}] starting unicorn..."

      execute_command server, %(source ~/.rvm/scripts/rvm),
                              %(cd #{deploy_directory}),
                              %(bundle exec #{unicorn} -c config/unicorn.rb -D -E #{environment})
    end

    def stop_server server
      info "[#{server}] stopping unicorn..."

      execute_command server, %(cd #{deploy_directory}),
                              %(kill \\`cat tmp/pids/unicorn.pid\\`)
    end

    def restart_server server
      info "[#{server}] restarting unicorn..."

      execute_command server, %(cd #{deploy_directory}),
                              %(kill -USR2 \\`cat tmp/pids/unicorn.pid\\`)
    end

    def run_migrations server
      info "[#{server}] running migrations..."

      execute_command server, %(cd #{deploy_directory}),
                              %(RAILS_ENV=#{environment} rake db:migrate db:seed)
    end

    def execute_in_parallel servers
      servers.map do |server|
        Thread.new(server) do |server|
          yield server
        end
      end.map {|thread| thread.join }
    end

    # options = {:exec => ?, :capture => ?}
    def execute_command server, *command_array
      options = {:exec => false, :capture => false}
      options.merge!(command_array.pop) if command_array.last.is_a?(Hash)

      command = build_command(server, command_array, options)

      if pretending
        info("[#{server}] #{command}")
      else
        if options[:exec]
          exec command
        else
          results = `#{command}`
          if options[:capture]
            return results
          else
            results.split("\n").each do |result|
              info("[#{server}] #{result}")
            end
          end
        end
      end
    end

    def build_command server, *commands_and_maybe_options
      return "" if commands_and_maybe_options.empty?

      if commands_and_maybe_options.last.is_a?(Hash)
        options = commands_and_maybe_options.pop
        command_array = commands_and_maybe_options
      else
        command_array = commands_and_maybe_options
        options = {}
      end

      commands = command_array.join " && "
      psuedo_tty = options[:exec] ? '-t ' : ''

      if use_gateway
        %(ssh #{psuedo_tty}#{gateway} 'ssh #{psuedo_tty}#{deploy_user}@#{server} "#{commands}"')
      else
        %(ssh #{psuedo_tty}#{deploy_user}@#{server} "#{commands}")
      end
    end

    def info message
      STDOUT.puts message
    end

    def fatal message
      info message
      exit 1
    end

  end
end
