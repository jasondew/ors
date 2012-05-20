class ORS
  module Commands
    class Console < Base
      def execute
        execute_command(ORS.config[:console_server],
                        prepare_environment_with_rvm,
                        %(if [ -f script/rails ]; then bundle exec rails console #{ORS.config[:environment]}; else ./script/console #{ORS.config[:environment]}; fi),
                        :exec => true)
      end

      def usage
        "./ors console [options]"
      end

      def description
        "Replaces current process and runs rails console."
      end
    end # Console < Base
  end
end
