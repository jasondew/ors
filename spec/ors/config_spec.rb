require "spec_helper"

describe ORS::Config do

  subject { class Foo; include ORS::Config; end; Foo.new }

  context ".parse_options" do
    it("should default pretend to false") { subject.pretending.should be_false }
    it("should default use_gateway to true") { subject.use_gateway.should be_true }
    it("should default rails2 to false") { subject.rails2.should be_false }

    it "should set the environment when it is given" do
      ORS::Config.parse_options %w(foobar -p)
      subject.environment.should == "foobar"
    end

    it "should set pretend to true if -p is given" do
      ORS::Config.pretending = false
      ORS::Config.parse_options %w(-p)

      subject.pretending.should be_true
    end

    it "should set pretend to true if --pretend is given" do
      ORS::Config.pretending = false
      ORS::Config.parse_options %w(--pretend)

      subject.pretending.should be_true
    end

    it "should set use_gateway to false if -ng is given" do
      ORS::Config.use_gateway = true
      ORS::Config.parse_options %w(-ng)

      subject.use_gateway.should be_false
    end

    it "should set use_gateway to false if --no-gateway is given" do
      ORS::Config.use_gateway = true
      ORS::Config.parse_options %w(--no-gateway)

      subject.use_gateway.should be_false
    end
  end

  context ".valid_options?" do

    it "should be true when there is a name and valid environment" do
      subject.name = "foo"
      subject.environment = "production"

      ORS::Config.valid_options?.should be_true
    end

    it "should be false when there is a name but an invalid environment" do
      subject.name = "foo"
      subject.environment = "-p"

      ORS::Config.valid_options?.should be_false
    end

    it "should be false when there is a valid environment but a blank name" do
      subject.name = ""
      subject.environment = "production"

      ORS::Config.valid_options?.should be_false
    end

  end

  context "#all_servers" do
    it "should return all servers" do
      subject.all_servers.should == (subject.web_servers + subject.app_servers + [subject.migration_server])
    end
  end

  context "config permanence" do
    before do
      class ORS::OtherConfig; include ORS::Config; end
      @other_config = ORS::OtherConfig.new

      class ORS::ConfigTest; include ORS::Config; end
      @some_config = ORS::ConfigTest.new
    end

    %w(use_gateway pretending).each do |accessor|
      it "should allow you to set #{accessor}" do
        ORS::Config.should respond_to("#{accessor}")
      end

      it "should know if its #{accessor} across classes" do
        ORS::Config.send("#{accessor}=", true)

        @some_config.send(accessor).should == true
        @other_config.send(accessor).should == true
      end
    end
  end

  context "#name_from_git" do
    {
     "git://github.com/testing/github.git" => "testing/github",
     "git://example.com/testing/gitlabhq.git" => "testing/gitlabhq",
     "git://github.com/testing/github" => "testing/github",
     "git@github.com:testing/github" => "testing/github",
     "git@ghub.com:testing/gitlabhq.git" => "testing/gitlabhq",
     "git@ghub.com:gitlabhq.git" => "gitlabhq",
     "git://ghub.com/gitlabhq.git" => "gitlabhq"
    }.each do |remote, name|
      it "should handle a remote origin url such as #{remote}" do
        stub(ORS::Config).git { mock!.config { {"remote.origin.url" => remote} }}
        ORS::Config.send(:name_from_git).should == name
      end
    end
  end

  context "#remote_from_git" do
    before do
      subject.remote_alias = "origin"
    end

    it "should raise an error if the remote doesn't exist" do
      mock(ORS::Config).git { mock!.config { {"remote.oregon.url" => "git://github.com/testing/git.git"} }}

      lambda { ORS::Config.send(:remote_from_git) }.should raise_error
    end

    it "should return the remote based on the remote alias (origin)" do
      stub(ORS::Config).git { mock!.config { {"remote.origin.url" => "git://github.com/testing/git.git"} }}

      ORS::Config.send(:remote_from_git).should == "git://github.com/testing/git.git"
    end

    it "should return the remote based on the remote alias (arbit)" do
      subject.remote_alias = "arbit"
      stub(ORS::Config).git { mock!.config { {"remote.arbit.url" => "git://github.com/arbit/git.git"} }}

      ORS::Config.send(:remote_from_git).should == "git://github.com/arbit/git.git"
    end
  end

end
