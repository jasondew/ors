require "spec_helper"

describe ORS::Commands::Logs do

  context "#execute" do
    it "should get logs from all of the app servers and then unify them" do
      mock(subject).pretending { false }
      mock(subject).app_servers { mock!.map { :logs }.subject }
      mock(ORS::LogUnifier).new(:logs) { mock!.unify { :output }.subject }
      mock(subject).puts(:output)

      subject.execute
    end

    it "should not call the LogUnifier if pretending" do
      mock(subject).pretending { true }
      mock(subject).app_servers { mock!.map { :logs }.subject }
      mock(ORS::LogUnifier).new(:logs).never

      subject.execute
    end
  end

end
