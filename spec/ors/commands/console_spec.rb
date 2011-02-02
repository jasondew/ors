require "spec_helper"

describe ORS::Commands::Console do

  context "#run" do
    it "should set pretending to true and call exec" do
      stub(subject).name {'abc/growhealthy'}
      stub(subject).environment {'production'}
      mock(subject).execute_command(is_a(String), true, is_a(String), is_a(String), is_a(String)).returns("command")
      subject.execute
    end
  end
end
