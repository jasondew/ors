module ORS
  module Config

    CONFIG_FILENAME="config/deploy.yml"

    mattr_accessor :name, :environment, :use_gateway, :pretending, :log_lines, :rails2, :deploy_hook, :remote_deploy_hook
    mattr_accessor :gateway, :deploy_user, :remote_alias, :base_path, :web_servers, :app_servers, :migration_server, :console_server, :cron_server
    mattr_accessor :options

    self.remote_alias = "origin"
    self.environment = "production"
    self.pretending = false
    self.use_gateway = true
    self.log_lines = 100

    module ModuleMethods

      def parse_options options
        self.name = name_from_git
        self.environment = options.shift unless options.empty? or options.first.match(/^-/)
        self.options = options.dup

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

      def git
        @git ||= Git.open(Dir.pwd)
      end

      private

      def remote_from_git
        if git.config.has_key?("remote.#{remote_alias}.url")
          git.config["remote.#{remote_alias}.url"]
        else
          raise StandardError, "There is no #{remote_alias} remote in your git config, please check your config/deploy.yml"
        end
      end

      def name_from_git
        remote_from_git.gsub(/^[\w]*(@|:\/\/)[^\/:]*(\/|:)([a-zA-Z0-9\/]*)(.git)?$/i, '\3')
      end
    end
    extend ModuleMethods

    def ruby_servers
      (app_servers + [console_server, cron_server, migration_server]).uniq
    end

    def all_servers
      (web_servers + ruby_servers).uniq
    end

    def revision
      Config.git.log(1).first.sha
    end

    def deploy_directory
      directory = File.join base_path, name

      if environment == "production"
        directory
      else
        "#{directory}_#{environment}"
      end
    end

    def remote_url
      @remote_url ||= remote_from_git
    end
  end
end
