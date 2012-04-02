module ORS::Commands

  class Changes < Base

    def execute
      results = execute_command console_server, prepare_environment, %(git show | head -1), :capture => true

      system('git', 'log', [$1, "remotes/#{remote_alias}/#{environment}"].join("..")) if results =~ /commit (.*)/
    end

  end

end
