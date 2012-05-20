class ORS
  module Commands
    class Start < Base
      def execute
        info "starting #{ORS.config[:name]} #{ORS.config[:environment]}..."

        execute_in_parallel(ORS.config[:app_servers]) {|server| start_server server }
      end
    end # Start < Base
  end
end
