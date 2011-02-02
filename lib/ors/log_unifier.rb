module ORS

  class LogUnifier

    attr_reader :logs

    def initialize *logs
      @logs = logs.join "\n\n"
    end

    def unify
      group_by_entry.sort_by {|entry| entry[:timestamp] }.map {|entry| entry[:lines].join("\n") }.flatten.join("\n\n\n")
    end

    private

    def group_by_entry
      entries = Array.new
      entry = {:lines => Array.new}

      logs.split(/\n/).each do |line|
        if line == ""
          unless entry[:lines].empty?
            entries << entry
            entry = {:lines => Array.new}
          end
        else
          if entry[:lines].empty?
            entry[:timestamp] = line.gsub(/^Started.*?(\d{4}-\d{2}-\d{2} \d{2}:\d{2}:\d{2}).*$/, '\1').gsub(/\D/, '')
          end

          entry[:lines] << line
        end
      end

      entries << entry

      entries
    end

  end

end
