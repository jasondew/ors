require "spec_helper"

describe ORS::Commands::Timestamps do

  context "#execute" do
    it "should get restart.timestamp from all of the app servers" do
      ORS.config[:pretending] = false
      ORS.config[:app_servers] = mock!.map { ["server", "timestamp"] }.subject

      mock($stdout).puts("server\ntimestamp")

      subject.execute
    end
  end

end
