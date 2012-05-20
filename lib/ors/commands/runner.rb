class ORS
  module Commands
    class Runner < Base
      def setup
        @code = ORS.config[:args].shift
      end

      def execute
        # need code to run
        fatal "ERROR: Missing 'ruby code'." if @code.nil?

        # get results
        results = execute_command(ORS.config[:console_server],
                                  prepare_environment,
                                  %(if [ -f script/rails ]; then bundle exec rails runner -e #{ORS.config[:environment]} \\"#{@code}\\"; else ./script/runner -e #{ORS.config[:environment]} \\"#{@code}\\"; fi),
                                  :capture => true, :quiet_ssh => true)

        # The central_logger gem spits this out
        results.sub!(/\AUsing BufferedLogger due to exception: .*?\n/, '')

        puts results
      end

      def usage
        "./ors runner 'ruby code here' [options]"
      end

      def description
        <<-END
Runs rails runner returning the result on STDOUT.
The ruby code will be transmitted within several nested quotes:  '"\"ruby code here\""'
Keep that in mind if you need to use quotes.
        END
      end
    end # Runner < Base
  end
end
