class ORS
  module Commands
    class Changes < Base
      def setup
        @local_ref = ORS.config[:args].shift
        parse_remote_and_or_branch
      end

      def execute
        results = execute_command(ORS.config[:console_server],
                                  prepare_environment_with_rvm,
                                  %(git show | head -1),
                                  :capture => true)

        system('git', 'log', [@local_ref, "remotes/#{ORS.config[:remote]}/#{ORS.config[:branch]}"].join("..")) if results =~ /commit (.*)/
      end

      def usage
        "./ors changes local_ref [remote|remote/branch] [options]"
      end

      def description
        "Detects changes between local commits and what is deployed"
      end
    end # Changes < Base
  end
end
