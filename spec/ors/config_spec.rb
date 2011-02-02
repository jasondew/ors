require "spec_helper"

describe ORS::Config do

  subject { class ORS::ConfigTest; include ORS::Config; end; ORS::ConfigTest.new }

  context "config permanence" do
    before do
      class ORS::OtherConfig; include ORS::Config; end
      @other_config = ORS::OtherConfig.new
    end

    %w(use_gateway pretending).each do |accessor|
      it "should allow you to set #{accessor}" do
        ORS::Config.should respond_to("#{accessor}")
      end

      it "should know if its #{accessor} across classes" do
        ORS::Config.send("#{accessor}=", true)

        subject.send(accessor).should == true
        @other_config.send(accessor).should == true
      end
    end
  end

  context ".parse_options" do
    it "should default pretend to false" do
      subject.pretending.should be_false
    end

    it "should default use_gateway to true" do
      subject.use_gateway.should be_true
    end
  end

  context "#all_servers" do
    it "should return all servers" do
      subject.all_servers.should == (subject.web_servers + subject.app_servers + [subject.migration_server])
    end
  end

end
