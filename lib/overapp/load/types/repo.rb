module Overapp
  module Load
    class Repo < Base
      def url; descriptor; end

      def load(base,ops)
        TmpDir.with_repo_path(url) do |dir|
          LocalDir.new(:descriptor => dir)
        end
      end
    end
  end
end