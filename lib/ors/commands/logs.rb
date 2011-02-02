module ORS::Commands
  class Logs < Base

    def execute
      all_logs = app_servers.map do |server|
        [
         server,
         execute_command(server,
                         %(cd #{deploy_directory}),
                         %(tail -500 log/#{environment}.log),
                         :capture => true)
        ]
      end

      puts ORS::LogUnifier.new(all_logs).unify
    end

  end
end
