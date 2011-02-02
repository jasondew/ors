module ORS::Commands

  class Deploy < Base

    def execute
      info "deploying #{name} #{environment}..."

      [Update, Migrate, Restart].each {|command| run command }
    end

  end

end
