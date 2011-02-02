require 'ors/commands/base'
Dir[File.join File.dirname(__FILE__), "commands", "*.rb"].each { |c| require c }

module ORS

  class Command

    module ClassMethods

      include ORS::Commands

      def run args
        command, *options = args
        klass = command.to_s.capitalize

        if available_commands.include? klass
          ORS::Config.name = name_from_git
          ORS::Config.environment = "production" #FIXME: this should be configurable

          #FIXME: validate options!

          Base.run ORS::Commands.const_get(klass)
        else
          Base.run Help
        end
      end

      private

      def available_commands
        ORS::Commands.constants.map {|klass| klass.to_s }
      end

      def name_from_git
        git.config["remote.origin.url"].gsub /.*?:(.*?).git/, '\1'
      end

      def git
        @git ||= Git.open(Dir.pwd)
      end

    end
    extend ClassMethods

  end

end
