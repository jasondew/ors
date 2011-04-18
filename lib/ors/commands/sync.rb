module ORS::Commands

  class Sync < Base

    def execute
      system "git co master && git co #{environment} && git pull && git merge master && git push && git co master"
    end

  end

end
