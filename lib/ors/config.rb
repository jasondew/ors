module ORS
  class Config
    class << self
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
    end
  end
end
