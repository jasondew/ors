class ORS
  module Commands
    class Update < Base

      def setup
        parse_remote_and_or_branch
      end

      def execute
        info "updating #{ORS.config[:name]} #{ORS.config[:environment]}..."

        execute_in_parallel(ORS.config[:all_servers]) {|server| update_code(server) }
        execute_in_parallel(ORS.config[:ruby_servers]) {|server| bundle_install(server) }

        execute_command(ORS.config[:cron_server],
                        prepare_environment,
                        %(if [ -f config/schedule.rb ]; then bundle exec whenever --update-crontab --set environment=#{ORS.config[:environment]} -i #{ORS.config[:name]}_#{ORS.config[:environment]}; fi))
      end
    end # Update < Base
  end
end
