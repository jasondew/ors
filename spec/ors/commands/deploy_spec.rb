require "spec_helper"

describe ORS::Commands::Deploy do

  context "#execute" do

    it "should call update, migrate, then restart" do
      mock(subject).info /deploying/

      mock(ORS::Commands::Update).run_without_setup
      mock(ORS::Commands::Migrate).run_without_setup
      mock(ORS::Commands::Restart).run_without_setup

      subject.execute
    end

  end

end
