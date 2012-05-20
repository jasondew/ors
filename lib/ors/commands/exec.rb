class ORS
  module Commands
    class Exec < Base

      def setup
        @command = ORS.config[:args].shift
      end

      def execute
        info "executing command for #{ORS.config[:name]} #{ORS.config[:environment]}..."

        execute_command migration_server, prepare_environment, %(bundle exec #{@command})
      end

      def usage
        "./ors exec command [options]"
      end
    end # Exec < Base
  end
end
