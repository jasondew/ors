module ORS
  class Config

    CONFIG_FILENAME = "config/deploy.yml"

    @@args = []
    @@options = {}

    def initialize(options)
      parse_options(options)
      parse_config_file
    end

    def _options
      @@options
    end

    def [](key)
      @@options[key]
    end

    def []=(key, value)
      @@options[key] = value
    end

    def parse_options(options)
      @@options[:pretending] = true if ar.delete("-p") || ar.delete("--pretending")

      @@options[:use_gateway] = false if ar.delete("-ng") || ar.delete("--no-gateway")

      # grab environment
      index = options.index("to") || options.index("from")
      unless index.nil?
        @@options[:environment] = options.delete_at(index + 1)
        options.delete_at(index)
      end


      @@options[:args] = options.dup

      set_default_options
    end

    def set_default_options
      @@options[:environment]    ||= "production"
      @@options[:remote]         ||= "origin"
      @@options[:branch]         ||= @@options[:environment]
      @@options[:pretending]       = false
      @@options[:use_gateway]      = true
      @@options[:log_lines]        = 100

      @@options[:gateway]          = "deploy-gateway"
      @@options[:user]             = "deployer"
      @@options[:base_path]        = "/var/www"
      @@options[:web_servers]      = %w(koala)
      @@options[:app_servers]      = %w(eel jellyfish squid)
      @@options[:migration_server] = "tuna"
      @@options[:console_server]   = "tuna"
      @@options[:cron_server]      = "tuna"
    end

    def parse_config_file
      if File.exists?(CONFIG_FILENAME)
        YAML.load(File.read(CONFIG_FILENAME)).each {|(name, value)| @@options[name.to_sym] = value
        end
      end
    end

    def finalize!
      @@options[:name] = name
      @@options[:remote_url] = remote_url
      @@options[:deploy_directory] = deploy_directory

      @@options[:revision] = git.log(1).first.sha

      @@options[:ruby_servers] = (@@options[:app_servers] + [@@options[:console_server], @@options[:cron_server], @@options[:migration_server]]).uniq
      @@options[:all_servers] = (@@options[:web_servers] + @@options[:ruby_servers]).uniq
    end

    def git
      @git ||= Git.open(Dir.pwd)
    end

    def valid?
      name.to_s.size > 0 and valid_environments.include?(@@options[:environment])
    end


    private

    #
    # some methods to help finalize the config
    #

    def remote_url
      @remote_url ||= if git.config.has_key?("remote.#{@@options[:remote]}.url")
                        git.config["remote.#{@@options[:remote]}.url"]
                      else
                        raise StandardError, "There is no #{@@options[:remote]} remote in your git config, please check your config/deploy.yml"
                      end
    end

    def name
      @name ||= remote_url.gsub(/^[\w]*(@|:\/\/)[^\/:]*(\/|:)([a-zA-Z0-9\/_-]*)(.git)?$/i, '\3')
    end

    def deploy_directory
      directory = File.join(base_path, name)

      if environment == "production"
        directory
      else
        "#{directory}_#{environment}"
      end
    end
  end
end
