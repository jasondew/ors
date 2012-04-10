class ORS

  class LogUnifier

    attr_reader :logs, :pretty_adjust

    def initialize logs
      @pretty_adjust = 0

      @logs = logs.inject(Hash.new) do |hash, (server, log_rows)|
        @pretty_adjust = [@pretty_adjust, server.length].max
        hash[server] = log_rows
        hash
      end
    end

    def unify
      group_by_entry.
        select {|entry| entry[:timestamp].size == 14 }.
        sort_by {|entry| entry[:timestamp] }.
        map do |entry|
          entry[:lines].
          map {|line| ["[#{entry[:server]}]".ljust(pretty_adjust + 3), line].join.strip }.
          join "\n"
        end.
        flatten.
        join("\n\n\n")
    end

    private

    def group_by_entry
      entries = Array.new

      logs.each do |server, log_rows|
        log_rows.split(/\n\n\n/).each do |line|
          line.gsub!(/^.*?Started/m, "Started") unless line =~ /\AStarted/
          timestamp, _ = line.scan(/^(?:Processing|Started).*?(\d{4}-\d{2}-\d{2} \d{2}:\d{2}:\d{2}).*$/).first

          entries << {:timestamp => timestamp.gsub(/\D/, ""), :lines => line.split(/\n/), :server => server} if timestamp
        end
      end

      entries
    end

  end

end
