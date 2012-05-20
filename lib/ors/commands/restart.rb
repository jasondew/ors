class ORS
  module Commands
    class Restart < Base
      def execute
        info "restarting #{ORS.config[:name]} #{ORS.config[:environment]}..."

        execute_in_parallel(ORS.config[:app_servers]) {|server| restart_server server }
      end
    end # Restart < Base
  end
end
