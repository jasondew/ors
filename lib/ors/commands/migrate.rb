module ORS::Commands

  class Migrate < Base

    def execute
      info "migrating #{name} #{environment}..."

      bundle_install migration_server
      run_migrations migration_server
    end

  end

end
