require "spec_helper"

describe ORS::Commands::Runner do

  context "#run" do
    before do
      ORS.config[:name] = 'abc/growhealthy'
      ORS.config[:environment] = 'production'
    end

    it "should require 'ruby code'" do
      lambda {subject.setup; subject.execute}.should raise_error
    end

    it "should be successful with some 'ruby code'" do
      ORS.config.parse_options ["ruby code"]
      mock(subject).execute_command(is_a(String), is_a(Array), is_a(String), is_a(Hash)).returns("results")


      lambda {subject.setup; subject.execute}.should_not raise_error
    end
  end
end
