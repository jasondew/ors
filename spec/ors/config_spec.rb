require File.join(File.dirname(__FILE__), %w[.. spec_helper])

describe ORS::Config do
  before do
    class ORS::ConfigTest; include ORS::Config; end
    class ORS::ConfigReal; include ORS::Config; end

    @config_test = ORS::ConfigTest.new
    @config_real = ORS::ConfigReal.new
  end

  %w(use_gateway pretending).each do |accessor|
    it "should allow you to set #{accessor}" do
      ORS::Config.should respond_to("#{accessor}")
    end

    it "should know if its #{accessor} across classes" do
      ORS::Config.send("#{accessor}=", true)

      @config_test.send(accessor).should == true
      @config_real.send(accessor).should == true
    end
  end

  it "should return all servers" do
    @config_test.all_servers.should == (@config_test.web_servers + @config_test.app_servers + [@config_test.migration_server])
  end
end
