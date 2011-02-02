module ORS

  class LogUnifier

    attr_reader :logs, :pretty_adjust

    def initialize logs
      @logs = logs.inject({}) do |hash, (server, log_rows)|
        @pretty_adjust = server.length if server.length > pretty_adjust.to_i
        hash[server] = log_rows
        hash
      end
    end

    def unify
      group_by_entry.sort_by {|entry| entry[:timestamp] }.map do |entry|
        entry[:lines].map do |line|
          ["[#{entry[:server]}]".ljust(pretty_adjust + 3),  line].join
        end.join("\n")
      end.flatten.join("\n\n\n")
    end

    private

    def group_by_entry
      entries = Array.new

      logs.each_pair do |server, log_rows|
        entry = {:lines => Array.new, :server => server}

        log_rows.split(/\n/).each do |line|
          if line == ""
            unless entry[:lines].empty?
              entries << entry
              entry = {:lines => Array.new, :server => server}
            end
          else
            if entry[:lines].empty?
              entry[:timestamp] = line.gsub(/^Started.*?(\d{4}-\d{2}-\d{2} \d{2}:\d{2}:\d{2}).*$/, '\1').gsub(/\D/, '')
            end

            entry[:lines] << line
          end
        end

        entries << entry
      end

      entries
    end

  end

end
