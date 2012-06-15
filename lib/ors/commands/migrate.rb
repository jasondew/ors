class ORS
  module Commands
    class Migrate < Base

      def execute
        if migrations_exist?
          info "migrating #{ORS.config[:name]} #{ORS.config[:environment]}..."
          run_migrations ORS.config[:migration_server]
        end
      end

      def migrations_exist?
        Dir.exists? File.join(%w{db migrate})
      end
    end # Migrate < Base
  end
end
