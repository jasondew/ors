require "spec_helper"

describe ORS::Commands::Base do

  context "#run" do

    it "should instantiate the command and call #execute on it" do
      klass = mock!.new { mock!.execute.subject }.subject
      subject.run klass
    end

  end

end
