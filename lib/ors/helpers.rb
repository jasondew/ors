class ORS
  module Helpers

    # Helpers for Commands when parsing in ARGV
    module ParseHelpers
      def parse_remote_and_or_branch
        option = ORS.config[:args].shift

        unless option.nil?
          if option.match(/^[a-zA-Z0-9-_]+\/[a-zA-Z0-9-_]+$/)
            remote, *branch = option.split("/")

            ORS.config[:remote] = remote
            ORS.config[:branch] = branch.join('/')
          else
            ORS.config[:remote] = option
          end
        end
      end
    end
    include ParseHelpers


    # Helpers for preparing to run a command on a server
    module PrepareHelpers
      def prepare_environment
        [%({ cd #{deploy_directory} > /dev/null; })]
      end

      def prepare_environment_with_rvm
        [%(source ~/.rvm/scripts/rvm)] + prepare_environment
      end

      def prepare_initial_environment
        # We do a source and a git checkout here because the master
        # branch may not always contain the proper rvmrc/Gemfile
        # we need when setting up the rest of the deploy
        prepare_environment_with_rvm + [
                                        %(git checkout -q -f #{ORS.config[:remote]}/#{ORS.config[:branch]}),
                                        %(git reset --hard),
                                        %(source .rvmrc)
                                       ]
      end
    end
    include PrepareHelpers

    # Helpers for commands for re-use
    module CommandHelpers
      def setup_repo server
        info "[#{server}] installing codebase..."

        execute_command server, %(cd #{ORS.config[:base_path]}),
        %(rm -rf #{ORS.config[:deploy_directory]}),
        %(git clone #{ORS.config[:remote_url]} #{ORS.config[:deploy_directory]}),
        %(mkdir -p #{ORS.config[:deploy_directory]}/tmp/pids),
        %(mkdir -p #{ORS.config[:deploy_directory]}/log)
      end

      def setup_ruby server
        info "[#{server}] installing ruby and gems..."

        execute_command server, prepare_initial_environment,
        %(gem install rubygems-update),
        %(gem update --system),
        %(gem install bundler),
        %(bundle install --without development test osx_development > bundler.log)
      end

      def update_code server
        info "[#{server}] updating codebase..."

        execute_command server, prepare_environment,
        %(git fetch #{ORS.config[:remote]}),
        %(git checkout -q -f #{ORS.config[:remote]}/#{ORS.config[:branch]}),
        %(git reset --hard),
        %(git submodule update --init)
      end

      def bundle_install server
        info "[#{server}] installing bundle..."

        execute_command server, prepare_environment_with_rvm,
        %(bundle install --without development test osx_development > bundler.log)
      end

      def start_server server
        info "[#{server}] starting unicorn..."

        execute_command server, prepare_environment_with_rvm,
        %(if [ -f config.ru ]; then RAILS_ENV=#{ORS.config[:environment]} bundle exec unicorn -c config/unicorn.rb -D; else RAILS_ENV=#{ORS.config[:environment]} bundle exec unicorn_rails -c config/unicorn.rb -D; fi)
      end

      def stop_server server
        info "[#{server}] stopping unicorn..."

        execute_command server, prepare_environment,
        %(kill \\`cat tmp/pids/unicorn.pid\\`)
      end

      def restart_server server
        info "[#{server}] restarting unicorn..."

        execute_command server, prepare_environment,
        %(kill -USR2 \\`cat tmp/pids/unicorn.pid\\`)
      end

      def run_migrations server
        info "[#{server}] running migrations..."

        execute_command server, prepare_environment_with_rvm,
        %(RAILS_ENV=#{ORS.config[:environment]} bundle exec rake db:migrate db:seed)
      end
    end
    include CommandHelpers

    #
    # How we actually execute/build commands
    #

    # options = {:exec => ?, :capture => ?, :quiet_ssh => ?}
    def execute_command(server, *command_array)
      options = {:exec => false, :capture => false, :quiet_ssh => false}
      options.merge!(command_array.pop) if command_array.last.is_a?(Hash)
      options[:local] = true if server.to_s == "localhost"

      command = build_command(server, command_array, options)

      if ORS.config[:pretending]
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
              info "[#{server}] #{result.chomp}\n"
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
      quiet_ssh = options[:quiet_ssh] ? '-q ' : ''

      if options[:local]
        commands
      else
        if ORS.config[:use_gateway]
          %(ssh #{quiet_ssh}#{psuedo_tty}#{ORS.config[:gateway]} 'ssh #{quiet_ssh}#{psuedo_tty}#{ORS.config[:user]}@#{server} "#{commands}"')
        else
          %(ssh #{quiet_ssh}#{psuedo_tty}#{ORS.config[:user]}@#{server} "#{commands}")
        end
      end
    end

    def execute_in_parallel servers
      servers.map do |server|
        Thread.new(server) do |server|
          yield server
        end
      end.map {|thread| thread.join }
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
