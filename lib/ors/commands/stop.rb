class ORS
  module Commands
    class Stop < Base
      def execute
        info "stopping #{ORS.config[:name]} #{ORS.config[:environment]}..."

        execute_in_parallel(ORS.config[:app_servers]) {|server| stop_server server }
      end
    end # Stop < Base
  end
end
