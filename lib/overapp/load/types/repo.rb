module Overapp
  module Load
    class Repo < Base
      def url; descriptor; end

      def load
        TmpDir.with_repo_path(url) do |dir|
          LocalDir.new(:descriptor => dir).load
        end
      end
    end
  end
end