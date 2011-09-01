module ORS::Commands
  class Runner < Base
    def execute
      begin
        code = ORS::Config.options[ ORS::Config.options.index{|e| e =~ /^(-c|--code)$/} + 1 ]
        raise if code.strip.empty?
      rescue
        fatal "ERROR: Missing option --code 'ruby code'."
      end
      results = execute_command console_server,
                      %(source ~/.rvm/scripts/rvm),
                      %({ cd #{deploy_directory} > /dev/null; }), # Silence RVM's "Using... gemset..."
                      %(if [ -f script/rails ]; then bundle exec rails runner -e #{environment} \\"#{code}\\"; else ./script/runner -e #{environment} \\"#{code}\\"; fi),
                      :capture => true, :quiet_ssh => true
      results.sub!(/\AUsing BufferedLogger due to exception: .*?\n/, '') # The central_logger gem spits this out without any way of shutting it up
      puts results
    end

    def help
      puts <<-END
Usage: ./ors runner [environment=production] --code "ruby code here" [options]

=== Description
Runs rails runner returning the result on STDOUT.
The ruby code will be transmitted within several nested quotes:  '"\"ruby code here\""'
Keep that in mind if you need to use quotes.

=== Options
--code       (or -c)   The code to run.
--pretend    (or -p)   Don't execute anything, just show me what you're going to do
--no-gateway (or -ng)  Don't use a gateway (if you're inside the firewall)
      END
    end
  end
end
