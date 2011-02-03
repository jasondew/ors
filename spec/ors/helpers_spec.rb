require "spec_helper"

describe ORS::Helpers do

  subject { class ORS::HelperTest; include ORS::Helpers; end; ORS::HelperTest.new }

  context "#build_command" do

    it "should return a blank string given no commands" do
      subject.build_command("server").should == ""
    end

    context "with gateway" do
      before { mock(subject).use_gateway.returns(true) }

      it "should build the command" do
        subject.build_command("server", %(cd /tmp)).should == %(ssh deploy-gateway 'ssh deployer@server "cd /tmp"')
      end

      it "should build the command with psuedo tty" do
        subject.build_command("server", %(cd /tmp), :exec => true).should == %(ssh -t deploy-gateway 'ssh -t deployer@server "cd /tmp"')
      end
    end

    context "without gateway" do
      before { mock(subject).use_gateway.returns(false) }

      it "should build the command" do
        subject.build_command("server", %(cd /tmp)).should == %(ssh deployer@server "cd /tmp")
      end

      it "should build the command with psuedo tty" do
        subject.build_command("server", %(cd /tmp), :exec => true).should == %(ssh -t deployer@server "cd /tmp")
      end
    end
  end
end
