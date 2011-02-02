module ORS
  module Config

    mattr_accessor :use_gateway, :pretending, :name, :environment

    self.pretending = false
    self.use_gateway = true

    module ModuleMethods

      def parse_options options
        self.environment = options.shift unless options.first.match(/^-/)

        options.each do |option|
          case option
            when "-p", "--pretend" then self.pretending = true
            when "-ng", "--no-gateway" then self.use_gateway = false
          end
        end
      end

      def valid_options?
        name.to_s.size > 0 and valid_environments.include?(environment)
      end

      def valid_environments
        %w(production demo staging)
      end

    end
    extend ModuleMethods

    def gateway
      "deploy-gateway"
    end

    def deploy_user
      "deployer"
    end

    def repo
      "ors_git"
    end

    def base_path
      "/var/www"
    end

    def web_servers
      %w(koala)
    end

    def app_servers
      %w(eel jellyfish squid)
    end

    def migration_server
      "tuna"
    end

    def console_server
      "tuna"
    end

    def ruby_servers
      app_servers + [migration_server]
    end

    def all_servers
      web_servers + app_servers + [migration_server]
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
