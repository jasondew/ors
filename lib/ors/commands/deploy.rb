class ORS
  module Commands
    class Deploy < Base

      def setup
        parse_remote_and_or_branch
      end

      def execute
        info "deploying #{ORS.config[:name]} #{ORS.config[:environment]}..."

        [Update, Symlink, Migrate].each {|command| command.run_without_setup }

        if ORS.config[:remote_deploy_hook]
          execute_in_parallel(ORS.config[:app_servers]) do |server|
            execute_command server, prepare_environment, "RAILS_ENV=#{ORS.config[:environment]} #{ORS.config[:remote_deploy_hook]}"
          end
        end

        Restart.run_without_setup

        eval ERB.new(ORS.config[:deploy_hook]).result(binding) if ORS.config[:deploy_hook]
      end

      def usage
        "./ors deploy [remote|remote/branch] [options]"
      end

      def description
        "Deploys given branch (origin/environment by default) to given environment"
      end
    end # Deploy < Base
  end
end
