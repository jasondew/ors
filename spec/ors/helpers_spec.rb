require "spec_helper"

describe ORS::Helpers do

  subject { class ORS::HelperTest; include ORS::Helpers; end; ORS::HelperTest.new }

  context "#execute_command" do
    before do
      stub(subject).pretending  { false }
      stub(subject).info(is_a(String)).returns "message"
      stub(subject).build_command.returns "command"
      stub(subject).`(is_a(String)) {'output'} # ` # syntax highlighting
    end

    context "without options" do
      it "should not fail" do
        lambda {subject.execute_command("server", "command1", "command2")}.should_not raise_error
      end

      it "should not run exec" do
        dont_allow(subject).exec(is_a(String))
        subject.execute_command("server", "command1", "command2")
      end
    end

    context "with options" do
      it "should run exec with exec option" do
        mock(subject).exec(is_a(String)) { "return" }
        subject.execute_command("server", "command1", "command2", :exec => true)
      end

      it "should not put results into stdout when capturing" do
        dont_allow(subject).info(is_a(String))
        subject.execute_command("server", "command1", "command2", :capture => true)
      end
    end
  end

  context "#build_command" do

    it "should return a blank string given no commands" do
      subject.build_command("server").should == ""
    end

    context "with gateway" do
      before do
        ORS.config[:use_gateway] = true
      end

      it "should build the command" do
        subject.build_command("server", %(cd /tmp)).should == %(ssh deploy-gateway 'ssh deployer@server "cd /tmp"')
      end

      it "should build the command with psuedo tty" do
        subject.build_command("server", %(cd /tmp), :exec => true).should == %(ssh -t deploy-gateway 'ssh -t deployer@server "cd /tmp"')
      end

      it "should build the command with quiet mode" do
        subject.build_command("server", %(cd /tmp), :quiet_ssh => true).should == %(ssh -q deploy-gateway 'ssh -q deployer@server "cd /tmp"')
      end
    end

    context "without gateway" do
      before do
        ORS.config[:use_gateway] = false
      end

      it "should build the command" do
        subject.build_command("server", %(cd /tmp)).should == %(ssh deployer@server "cd /tmp")
      end

      it "should build the command with psuedo tty" do
        subject.build_command("server", %(cd /tmp), :exec => true).should == %(ssh -t deployer@server "cd /tmp")
      end

      it "should build the command with quiet mode" do
        subject.build_command("server", %(cd /tmp), :quiet_ssh => true).should == %(ssh -q deployer@server "cd /tmp")
      end
    end
  end
end
