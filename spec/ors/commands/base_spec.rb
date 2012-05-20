require "spec_helper"

describe ORS::Commands::Base do

  before do
    @command = ORS::Commands::Base.new
    mock(ORS::Commands::Base).new { @command }
  end

  context ".run" do
    it "should instantiate the command and call #setup and #execute on it" do
      mock(ORS.config).finalize! {true}
      mock(ORS.config).valid? {true}
      mock(@command).setup.subject
      mock(@command).execute.subject

      ORS::Commands::Base.run
    end
  end

  context ".run_without_setup" do
    it "should not run #setup but run #execute" do
      dont_allow(@command).setup.subject
      mock(@command).execute.subject

      ORS::Commands::Base.run_without_setup
    end
  end
end
