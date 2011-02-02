require "spec_helper"

describe ORS::Commands do

  before { extend ORS::Commands }

  context "#help" do

    it "should display the help documentation" do
      mock(self).puts is_a(String)
      help
    end

  end

end
