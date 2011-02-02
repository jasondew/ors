require "spec_helper"

describe ORS::Commands::Base do

  context ".run" do

    it "should instantiate the command and call #execute on it" do
      klass = mock!.new { mock!.execute.subject }.subject
      ORS::Commands::Base.run klass
    end

  end

  context "#run" do
    it "should call the class method" do
      mock(ORS::Commands::Base).run("Foo")
      subject.run "Foo"
    end
  end

end
