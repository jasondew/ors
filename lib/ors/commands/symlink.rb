class ORS
  module Commands
    class Symlink < Base

      def setup
        parse_remote_and_or_branch
      end

      def execute
        info "symlinking #{ORS.config[:name]} #{ORS.config[:environment]}..."

        execute_in_parallel(ORS.config[:ruby_servers]) do |server|
          info "[#{server}] symlinking..."
          execute_command(server,
                          prepare_environment,
                          #%(if [ -d config/deploy ]; then cd config/deploy; for i in ./**/*; do if [ -f \\\$i ]; then echo \\\$i; fi; done; cd ../../; fi))
                          %(if [ -d config/deploy ]; then cd config/deploy; for i in ./**/*; do if [ -f \\\$i ]; then ln -nfs #{ORS.config[:deploy_directory]}/config/deploy/\\\$i ../../\\\$i; fi; done; cd ../../; fi))

        end
      end

      def usage
        "./ors symlink [remote|remote/branch] [options]"
      end

      def description
        "Symlinks files in config/deploy/ in given branch (origin/environment by default) to given environment"
      end
    end # Deploy < Base
  end
end
