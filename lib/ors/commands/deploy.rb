module ORS::Commands

  class Deploy < Base

    def execute
      info "deploying #{name} #{environment}..."

      [Update, Migrate, Restart].each {|command| run command }

      eval ERB.new(deploy_hook).result(binding) if deploy_hook

      if remote_deploy_hook
        execute_in_parallel(app_servers) do |server|
          execute_command server, prepare_environment, "RAILS_ENV=#{environment} #{remote_deploy_hook}"
        end
      end
    end

  end

end
