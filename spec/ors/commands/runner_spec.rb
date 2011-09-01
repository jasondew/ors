require "spec_helper"

describe ORS::Commands::Runner do

  context "#run" do
    before do
      stub(subject).name {'abc/growhealthy'}
      stub(subject).environment {'production'}
    end

    it "should require --code 'ruby code'" do
      lambda {subject.execute}.should raise_error
    end

    it "should require an argument to --code" do
      ORS::Config.parse_options %w(--code)
      lambda {subject.execute}.should raise_error
    end

    it "should require an argument to -c" do
      ORS::Config.parse_options %w(--c)
      lambda {subject.execute}.should raise_error
    end

    it "should require a non-empty argument to --code" do
      ORS::Config.parse_options ['--code', ' ']
      lambda {subject.execute}.should raise_error
    end

    it "should be successful with an argument to --code" do
      ORS::Config.parse_options %w(--code true)
      mock(subject).execute_command(is_a(String), is_a(String), is_a(String), is_a(String), is_a(Hash)).returns("results")
      lambda {subject.execute}.should_not raise_error
    end

    it "should be successful with an argument to -c" do
      ORS::Config.parse_options %w(-c true)
      mock(subject).execute_command(is_a(String), is_a(String), is_a(String), is_a(String), is_a(Hash)).returns("results")
      lambda {subject.execute}.should_not raise_error
    end
  end
end
