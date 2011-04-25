module ORS::Commands

  class Sync < Base

    def execute
      if options.first == '--all'
        environments = ORS::Config.valid_environments
      else
        environments = [environment]
      end

      environments.each do |environment|
        unless ORS::Config.git.branches[environment].nil?
          info "Syncing environment/branch #{environment}..."
          execute_command :localhost, %(git checkout master),
                                      %(git checkout #{environment}),
                                      %(git pull),
                                      %(git rebase master),
                                      %(git push),
                                      %(git checkout master)
        end
      end
    end

  end

end
