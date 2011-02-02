require "spec_helper"

describe ORS::Helpers do

  subject { class ORS::HelperTest; include ORS::Helpers; end; ORS::HelperTest.new }

  it "should return the remote command with gateway" do
    mock(subject).use_gateway.returns(true)
    subject.build_command("server", %(cd /tmp)).should == %(ssh deploy-gateway 'ssh deployer@server "cd /tmp"')
  end

  it "should return the remote command without gateway" do
    mock(subject).use_gateway.returns(false)
    subject.build_command("server", %(cd /tmp)).should == %(ssh deployer@server "cd /tmp")
  end
end
