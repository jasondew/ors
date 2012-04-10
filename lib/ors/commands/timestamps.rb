class ORS
  module Commands

    # ors timestamps
    # ors timestamps from staging
    class Timestamps < Base
      def execute
        timestamps = ORS.config[:app_servers].map do |server|
          [
           "[#{server}] ",
           execute_command(server, prepare_environment, %(cat restart.timestamp), :capture => true)
          ].join
        end.join("\n")

        puts timestamps unless pretending
      end

      def usage
        "./ors check [options]"
      end

      def description
        "Prints out contents of restart.timestamp on the app servers"
      end
    end # Timestamps < Base
  end
end
