module ORS::Commands
  class Console < Base
    def run
      # set pretending to true to get back command then exec it since
      # we don't want this to execute remotely
      ORS::Config.pretending = true

      exec remote_execute(console_server,
                          %(cd #{deploy_directory}),
                          %(rails console #{environment}))
    end

    def help
    end
  end
end
