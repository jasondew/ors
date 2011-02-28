module ORS
  module Config

    CONFIG_FILENAME="config/deploy.yml"

    mattr_accessor :name, :environment, :use_gateway, :pretending, :log_lines, :rails2
    mattr_accessor :gateway, :deploy_user, :repo, :base_path, :web_servers, :app_servers, :migration_server, :console_server, :cron_server

    self.environment = "production"
    self.pretending = false
    self.use_gateway = true
    self.log_lines = 100

    module ModuleMethods

      def parse_options options
        self.name = name_from_git
        self.environment = options.shift unless options.empty? or options.first.match(/^-/)

        options.each do |option|
          case option
            when "-p", "--pretend" then self.pretending = true
            when "-ng", "--no-gateway" then self.use_gateway = false
          end
        end
      end

      def parse_config_file
        if File.exists?(CONFIG_FILENAME)
          YAML.load(File.read(CONFIG_FILENAME)).each {|(name, value)| send "#{name}=", value }
        else
          self.gateway          = "deploy-gateway"
          self.deploy_user      = "deployer"
          self.repo             = "ors_git"
          self.base_path        = "/var/www"
          self.web_servers      = %w(koala)
          self.app_servers      = %w(eel jellyfish squid)
          self.migration_server = "tuna"
          self.console_server   = "tuna"
          self.cron_server      = "tuna"
        end
      end

      def valid_options?
        name.to_s.size > 0 and valid_environments.include?(environment)
      end

      def valid_environments
        %w(production demo staging)
      end

      private

      def name_from_git
        git.config["remote.origin.url"].gsub /.*?:(.*?).git/, '\1'
      end

      def git
        @git ||= Git.open(Dir.pwd)
      end

    end
    extend ModuleMethods

    def ruby_servers
      (app_servers + [migration_server]).uniq
    end

    def all_servers
      (web_servers + app_servers + [migration_server]).uniq
    end

    def deploy_directory
      directory = File.join base_path, name

      if environment == "production"
        directory
      else
        "#{directory}_#{environment}"
      end
    end

  end
end
