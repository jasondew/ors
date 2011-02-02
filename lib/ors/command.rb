Dir[File.join File.dirname(__FILE__), "commands", "*.rb"].each { |c| require c }

module ORS

  class Command

    module ClassMethods

      include ORS::Commands

      def run args
        command, *options = args
        klass = command.to_s.capitalize

        if available_commands.include? klass
          # process and validate options, set up Config
          Base.run ORS::Commands.const_get(klass)
        else
          Base.run Help
        end
      end

      def available_commands
        ORS::Commands.constants.map {|klass| klass.to_s }
      end

    end
    extend ClassMethods

  end

end
