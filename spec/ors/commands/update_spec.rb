require "spec_helper"

describe ORS::Commands::Update do

  context "#run" do
    before do
      ORS::Config.parse_options []
      ORS::Config.parse_config_file
    end

    it "should update code, bundle install, and set up cron" do
      stub(subject).all_servers { :all_servers }
      stub(subject).ruby_servers { :ruby_servers }
      stub(subject).cron_server { :cron_server }

      mock(subject).info /updating/
      mock(subject).execute_in_parallel(:all_servers)
      mock(subject).execute_in_parallel(:ruby_servers)
      mock(subject).execute_command(:cron_server, is_a(Array), is_a(String))

      subject.execute
    end
  end
end
