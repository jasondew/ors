module ORS::Commands
  class Ruby < Base
    def execute
      info "setting up ruby/rubygems for #{name} #{environment}..."
      execute_in_parallel(ruby_servers) {|server| setup_ruby server }
    end
  end
end
