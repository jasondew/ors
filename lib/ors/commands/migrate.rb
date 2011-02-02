module ORS::Commands

  class Migrate < Base

    def execute
      info "migrating #{name} #{environment}..."

      run_migrations migration_server
    end

  end

end
