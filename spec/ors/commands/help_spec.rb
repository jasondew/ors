require "spec_helper"

describe ORS::Commands::Help do

  context "#run" do

    it "should display the help documentation" do
      mock(subject).puts is_a(String)
      subject.execute
    end

  end

end
