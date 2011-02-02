require "spec_helper"

describe ORS::Commands::Deploy do

  context "#execute" do

    it "should call update, migrate, then restart" do
      mock(subject).info /deploying/

      mock(subject).run(ORS::Commands::Update)
      mock(subject).run(ORS::Commands::Migrate)
      mock(subject).run(ORS::Commands::Restart)

      subject.execute
    end

  end

end
