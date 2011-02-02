module ORS
  module Utils

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
        command = %(ssh #{ORS::Config.gateway} 'ssh #{ORS::Config.deploy_user}@#{server} "#{commands}"')
      else
        command = %(ssh #{ORS::Config.deploy_user}@#{server} "#{commands}")
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
