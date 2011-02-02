require "spec_helper"

describe ORS::Commands::Console do

  context "#run" do
    before do
      ORS::Config.name = 'abc/growhealthy'
      ORS::Config.environment = 'production'
    end

    it "should set pretending to true and call exec" do
      mock(subject).exec(is_a(String))
      mock(subject).remote_execute(is_a(String), is_a(String), is_a(String)).returns("command")
      subject.execute
    end
  end
end
