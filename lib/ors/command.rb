require "ors/commands/base"
Dir[File.join File.dirname(__FILE__), "commands", "*.rb"].each { |c| require c }

module ORS

  class Command

    module ClassMethods

      include ORS::Commands

      def run args
        command, *options = args
        klass = command.to_s.capitalize

        if command =~ /-*version/i
          puts "ORS v#{ORS::VERSION}"
        else
          if available_commands.include? klass
            ORS::Config.parse_options options
            ORS::Config.parse_config_file

            if ORS::Config.valid_options?
              Base.run ORS::Commands.const_get(klass)
            else
              puts "ERROR: Invalid options given."
              Base.run Help
            end
          else
            Base.run Help
          end
        end
      end

      private

      def available_commands
        ORS::Commands.constants.map {|klass| klass.to_s }
      end

    end
    extend ClassMethods

  end

end
