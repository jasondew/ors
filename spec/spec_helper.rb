require File.expand_path(File.expand_path("../../lib/ors", __FILE__))

Dir[File.expand_path("spec/support/**/*.rb", __FILE__)].each {|f| require f}

RSpec.configure do |config|
  config.mock_with :rr
end
