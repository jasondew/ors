class ORS
  module Commands
    class Logs < Base

      def execute
        all_logs = app_servers.map do |server|
          [
           server,
           execute_command(server,
                           prepare_environment,
                           %(tail -n #{ORS.config[:log_lines]} log/#{ORS.config[:environment]}.log),
                           :capture => true)
          ]
        end

        puts ORS::LogUnifier.new(all_logs).unify unless pretending
      end
    end # Logs < Base
  end
end
