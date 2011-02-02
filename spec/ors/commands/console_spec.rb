require "spec_helper"

describe ORS::Commands::Console do

  context "#run" do
    it "should set pretending to true and call exec" do
      mock(self).exec
      mock(self).remote_execute
      subject.run
    end
  end
end
