module ORS::Commands

  class Changes < Base

    def execute
      results = execute_command console_server, %(cd #{deploy_directory}), %(git show | head -1), :capture => true
      if results =~ /commit (.*)/
        system 'git', 'log', [$1, "remotes/origin/#{environment}"].join("..") 
      end
    end

  end

end
