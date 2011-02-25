module ORS::Commands

  class Env < Base

    def execute
      puts "ORS Config"
      puts "=" * 80

      [:name, :environment, :use_gateway, :pretending, :log_lines, :rails2, :gateway, :deploy_user,
       :repo, :base_path, :web_servers, :app_servers, :migration_server, :console_server].each do |config_variable|
        puts "#{config_variable}: #{ORS::Config.send(config_variable)}"
      end
    end

  end
end
