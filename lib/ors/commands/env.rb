module ORS::Commands

  class Env < Base

    def execute
      puts "ORS v#{ORS::VERSION} configuration:\n\n"

      [:name, :environment, :use_gateway, :pretending, :log_lines, :rails2, :gateway, :deploy_user, :repo, :remote,
       :base_path, :deploy_hook, :remote_deploy_hook, :web_servers, :app_servers, :migration_server, :console_server, :cron_server].each do |config_variable|
        puts "%20s: %-40s" % [config_variable, ORS::Config.send(config_variable).inspect]
      end
    end

  end
end
