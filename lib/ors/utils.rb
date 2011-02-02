module ORS

  module Utils

    GATEWAY = "deploy-gateway"
    DEPLOY_USER = "deployer"

    def execute_in_parallel servers
      servers.map do |server|
        Thread.new(server) do |server|
          yield server
        end
      end.map {|thread| thread.join }
    end

    def remote_execute server, *command_array
      commands = command_array.join " && "

      if use_gateway
        command = %(ssh #{GATEWAY} 'ssh #{DEPLOY_USER}@#{server} "#{commands}"')
      else
        command = %(ssh #{DEPLOY_USER}@#{server} "#{commands}")
      end

      (pretending ? command : %x[#{command}]).split("\n").each do |result|
        info("[#{server}] #{result}")
      end
    end

    def info message
      STDOUT.puts message
    end

    def fatal message
      info message
      exit 1
    end
  end

end
