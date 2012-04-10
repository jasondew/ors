class ORS
  def self.config(options = [])
    @config ||= ORS::Config.new(options)
  end

  def run args
    command, *options = args
    klass_string = command.to_s.capitalize

    # setup initial config
    ORS.config(options)

    # determine command to use
    if command =~ /-*version/i
      puts "ORS v#{ORS::VERSION}"
    else
      if available_commands.include? klass_string

        if ORS.config.valid?
          ORS::Commands.const_get(klass_string).run
        else
          info "ERROR: Invalid options given."
          ORS::Commands::Help.run
        end
      else
        ORS::Commands::Help.run
      end
    end
  end

  private

  def available_commands
    ORS::Commands.constants.map {|klass| klass.to_s }
  end

end
