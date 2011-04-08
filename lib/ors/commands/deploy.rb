module ORS::Commands

  class Deploy < Base

    def execute
      info "deploying #{name} #{environment}..."

      [Update, Migrate, Restart].each {|command| run command }

      eval ERB.new(deploy_hook).result(binding) if deploy_hook
    end

  end

end
