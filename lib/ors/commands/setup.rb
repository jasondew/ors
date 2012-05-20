class ORS
  module Commands
    class Setup < Base

      def execute
        info "setting up #{ORS.config[:name]} #{ORS.config[:environment]}..."

        info "Are you sure? ('yes' + ctrl+D^2)"
        if ORS.config[:pretending] || STDIN.read == "yes"
          execute_in_parallel(ORS.config[:all_servers]) {|server| setup_repo server }

          Ruby.run_without_setup

          execute_command(ORS.config[:migration_server],
                          prepare_environment,
                          %(RAILS_ENV=#{environment} bundle exec rake db:create))
        else
          info "Setup aborted."
        end
      end
    end # Setup < Base
  end
end
