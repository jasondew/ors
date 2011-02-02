require "spec_helper"

describe ORS::Command do

  subject { ORS::Command }

  context ".run" do

    it "should execute help when the command is help" do
      mock(subject).help { true }
      subject.run ["help"]
    end

    it "should execute help when no command is given" do
      mock(subject).help { true }
      subject.run []
    end

    it "should execute help when an unknown command is given" do
      mock(subject).help { true }
      subject.run ["as0d9fja0s9djf"]
    end

  end

end
