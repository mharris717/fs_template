module Overapp
  module Load
    class LocalDir < Base
      def path; descriptor; end

      def load
        if Overapp::Project.project? path
          Project.new(:descriptor => path).load
        else
          RawDir.new(:descriptor => path).load
        end
      end
    end
  end
end