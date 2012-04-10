class ORS
  module Commands
    class Base
      include ORS::Helpers

      module ClassMethods
        def run_without_setup
          new.execute
        end

        def run
          command = new
          command.setup

          # now that the command has had a chance at the args
          # we let our config finish its setup of variables
          ORS.config.finalize!

          # now execute the command
          command.execute
        end
      end
      extend ClassMethods

      def setup
      end

      def usage
        "./ors base [options]"
      end

      def description
        "Base Command Class"
      end

      def help_options
        <<-END
=== Options
from|to environment    Set which environment to use (default production)
--pretend    (or -p)   Don't execute anything, just show me what you're going to do
--no-gateway (or -ng)  Don't use a gateway (if you're inside the firewall)
        END
      end

      def help
        puts <<-END
Usage: #{usage}

=== Description
#{description}

#{help_options}
        END
      end
    end
  end
end
