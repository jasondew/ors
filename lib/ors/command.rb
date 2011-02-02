Dir[File.join File.dirname(__FILE__), "commands", "*.rb"].each { |c| puts c }
Dir[File.join File.dirname(__FILE__), "commands", "*.rb"].each { |c| require c }

module ORS

  class Command

    module ClassMethods

      include ORS::Commands

      def run args
        command, *options = args
        method_name = command.to_s.downcase

        # process options, sets up Config

        if %w(help).include?(method_name)
          send method_name
        else
          help
        end
      end

    end
    extend ClassMethods

  end

end
