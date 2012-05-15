class ORS
  module Commands
    class Symlink < Base

      def setup
        parse_remote_and_or_branch
      end

      def execute
        info "symlinking #{ORS.config[:name]} #{ORS.config[:environment]}..."

        execute_in_parallel(ORS.config[:ruby_servers]) do |server|
          execute_command(server,
                          prepare_environment,
                          %(if [ -f config/deploy ]; then cd config/deploy; for i in `find ./ -type f`; do ln -s `pwd`/$i ../../$i; done; cd ../../; fi),
                          :exec => true)

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
