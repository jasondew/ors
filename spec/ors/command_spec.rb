require "spec_helper"

describe ORS::Command do

  subject { ORS::Command }

  context ".run" do

    it "should execute help when the command is help" do
      mock(ORS::Commands::Help).new { mock!.execute.subject }
      subject.run ["help"]
    end

    it "should execute help when no command is given" do
      mock(ORS::Commands::Help).new { mock!.execute.subject }
      subject.run []
    end

    it "should execute help when an unknown command is given" do
      mock(ORS::Commands::Help).new { mock!.execute.subject }
      subject.run ["as0d9fja0s9djf"]
    end

  end

end
