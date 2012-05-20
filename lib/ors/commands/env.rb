class ORS
  module Commands
    class Env < Base

      def execute
        puts "ORS v#{ORS::VERSION} configuration:\n\n"


        ORS.config._options.each_pair do |key, value|
          puts "%20s: %-40s" % [key, value.inspect]
        end
      end
    end # Env < Base
  end
end
