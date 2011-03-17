require "spec_helper"

describe ORS::Commands::Check do

  context "#execute" do
    it "should get restart.timestamp from all of the app servers" do
      mock(subject).pretending { false }
      mock(subject).app_servers { mock!.map { ["server", "timestamp"] }.subject }
      mock(subject).puts("server\ntimestamp")

      subject.execute
    end
  end

end
