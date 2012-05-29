require "spec_helper"

describe ORS::Commands::Setup do

  before do
    @command = ORS::Commands::Setup.new
    mock(ORS::Commands::Setup).new { @command }

    # Don't spew all over STDOUT
    stub(@command).info
  end

  it "should set up all servers and create the database" do
    ORS.config[:environment] = "production"
    ORS.config[:all_servers] = [:all_servers]
    ORS.config[:migration_server] = :migration_server
    stub(STDIN).read { "yes" }
    stub(@command).prepare_environment { :prepare_environment }

    mock(@command).setup_repo :all_servers
    mock(ORS::Commands::Ruby).run_without_setup
    mock(@command).execute_command :migration_server, :prepare_environment,
      /RAILS_ENV=production/

    ORS::Commands::Setup.run_without_setup
  end
end
