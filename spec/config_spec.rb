require File.join(File.dirname(__FILE__), %w[spec_helper])

describe ORS::Config do
  before do
    class ORS::ConfigTest; include ORS::Config; end
    @config_test = ORS::ConfigTest.new
  end

  %w(use_gateway pretending rails_2).each do |accessor|
    it "should allow you to set #{accessor}" do
      ORS::Config.instance_methods.should include("#{accessor}=")
      ORS::Config.instance_methods.should include("#{accessor}")
    end
  end

  it "should return all servers" do
    @config_test.all_servers.should == (@config_test.web_servers + @config_test.app_servers + [@config_test.migration_server])
  end
end
