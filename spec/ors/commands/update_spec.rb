require "spec_helper"

describe ORS::Commands::Update do

  context "#run" do
    it "should update code, bundle install, and set up cron" do
      stub(subject).all_servers { :all_servers }
      stub(subject).ruby_servers { :ruby_servers }
      stub(subject).cron_server { :cron_server }

      mock(subject).info /updating/
      mock(subject).execute_in_parallel(:all_servers)
      mock(subject).execute_in_parallel(:ruby_servers)
      mock(subject).execute_command(:cron_server, is_a(String), is_a(String))

      subject.execute
    end
  end
end
