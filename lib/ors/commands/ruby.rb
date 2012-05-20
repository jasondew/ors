class ORS
  module Commands
    class Ruby < Base
      def execute
        info "setting up ruby/rubygems for #{ORS.config[:name]} #{ORS.config[:environment]}..."
        execute_in_parallel(ORS.config[:ruby_servers]) {|server| setup_ruby server }
      end
    end # Ruby < Base
  end
end
