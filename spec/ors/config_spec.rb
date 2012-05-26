require "spec_helper"

describe ORS::Config do

  subject { ORS::Config.new([]) }

  context ".parse_options" do
    it("should default pretend to false") { subject[:pretending].should be_false }
    it("should default use_gateway to true") { subject[:use_gateway].should be_true }

    it "should set the environment when it is given" do
      subject.parse_options %w(to foobar -p)
      subject[:environment].should == "foobar"
    end

    it "should set pretend to true if -p is given" do
      subject[:pretending] = false
      subject.parse_options %w(-p)

      subject[:pretending].should be_true
    end

    it "should set pretend to true if --pretend is given" do
      subject[:pretending] = false
      subject.parse_options %w(--pretend)

      subject[:pretending].should be_true
    end

    it "should set use_gateway to false if -ng is given" do
      subject[:use_gateway] = true
      subject.parse_options %w(-ng)

      subject[:use_gateway].should be_false
    end

    it "should set use_gateway to false if --no-gateway is given" do
      subject[:use_gateway] = true
      subject.parse_options %w(--no-gateway)

      subject[:use_gateway].should be_false
    end
  end

  context ".valid?" do

    it "should be true when there is a name" do
      mock(subject).name { "foo" }

      subject.valid?.should be_true
    end

    it "should be false when there is a blank name" do
      mock(subject).name { "" }

      subject.valid?.should be_false
    end

  end

  context "#all_servers" do
    it "should return all servers" do
      subject.finalize!
      subject[:all_servers].should == (subject[:web_servers] + subject[:app_servers] + [subject[:migration_server]])
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
     "git://ghub.com/gitlabhq.git" => "gitlabhq",
     "git://ghub.com/level_git.git" => "level_git",
     "git://ghub.com/level-up/two.git" => "level-up/two",
     "git@mygitrepo:mywebsite.com/someapp" => "mywebsite.com/someapp"
    }.each do |remote, name|
      it "should handle a remote origin url such as #{remote}" do
        stub(subject).git { mock!.config { {"remote.origin.url" => remote} }}
        subject.send(:name).should == name
      end
    end
  end

  context "#remote_from_git" do
    before do
      subject[:remote] = "origin"
    end

    it "should raise an error if the remote doesn't exist" do
      stub(subject).git { mock!.config { {"remote.oregon.url" => "git://github.com/testing/git.git"} }}

      lambda { subject.send(:remote_url) }.should raise_error
    end

    it "should return the remote based on the remote alias (origin)" do
      stub(subject).git { mock!.config { {"remote.origin.url" => "git://github.com/testing/git.git"} }}

      subject.send(:remote_url).should == "git://github.com/testing/git.git"
    end

    it "should return the remote based on the remote alias (arbit)" do
      subject[:remote] = "arbit"
      stub(subject).git { mock!.config { {"remote.arbit.url" => "git://github.com/arbit/git.git"} }}

      subject.send(:remote_url).should == "git://github.com/arbit/git.git"
    end
  end

end
