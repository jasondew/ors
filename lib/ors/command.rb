module ORS

  class Command

    module ClassMethods

      def run args
        command, *options = args
        method_name = command.to_s.downcase

        help and return unless %w(help).include?(method_name)
        send method_name
      end

    end
    extend ClassMethods

  end

end
