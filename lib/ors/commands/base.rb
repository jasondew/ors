module ORS::Commands

  class Base

    def run command_klass
      command_klass.new.execute
    end

  end

end
