class ORS
  module Commands
    class Migrate < Base

      def execute
        info "migrating #{ORS.config[:name]} #{ORS.config[:environment]}..."

        run_migrations ORS.config[:migration_server]
      end
    end # Migrate < Base
  end
end
