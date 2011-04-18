module ORS::Commands

  class Sync < Base

    def execute
      if options.first == '--all'
        environments = ORS::Config.valid_environments
      else
        environments = [environment]
      end

      environments.each do |e|
        unless ORS::Config.git.branches[e].nil?
          info "Syncing environment/branch #{e}..."
          system "git co master && git co #{e} && git pull && git merge master && git push && git co master"
        end
      end
    end

  end

end
