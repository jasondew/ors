require "spec_helper"

describe ORS do

  subject { ORS.new }

  context ".run" do
    before do
      @command = ORS::Commands::Help.new
      mock(ORS::Commands::Help).new { @command }
      mock(@command).setup { "setup" }
      mock(@command).execute { "execute" }
    end

    it "should execute help when the command is help" do
      subject.run ["help"]
    end

    it "should execute help when no command is given" do
      subject.run []
    end

    it "should execute help when an unknown command is given" do
      subject.run ["as0d9fja0s9djf"]
    end
  end

  context ".run with version" do
    it "should show the version when given version as a command" do
      mock($stdout).puts("ORS v#{ORS::VERSION}")
      subject.run ["version"]
    end
  end
end
