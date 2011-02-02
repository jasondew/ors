require "spec_helper"

describe ORS::Helpers do

  subject { class ORS::HelperTest; include ORS::Helpers; end; ORS::HelperTest.new }

  context "with gateway" do
    it "should build the command" do
      mock(subject).use_gateway.returns(true)
      subject.build_command("server", [%(cd /tmp)], :exec => false).should == %(ssh deploy-gateway 'ssh deployer@server "cd /tmp"')
    end

    it "should build the command with psuedo tty" do
      mock(subject).use_gateway.returns(true)
      subject.build_command("server", [%(cd /tmp)], :exec => true).should == %(ssh -t deploy-gateway 'ssh -t deployer@server "cd /tmp"')
    end
  end

  context "without gateway" do
    it "should build the command" do
      mock(subject).use_gateway.returns(false)
      subject.build_command("server", [%(cd /tmp)], :exec => false).should == %(ssh deployer@server "cd /tmp")
    end

    it "should build the command with psuedo tty" do
      mock(subject).use_gateway.returns(false)
      subject.build_command("server", [%(cd /tmp)], :exec => true).should == %(ssh -t deployer@server "cd /tmp")
    end
  end
end
