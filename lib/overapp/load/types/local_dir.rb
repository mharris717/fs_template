module Overapp
  module Load
    class LocalDir < Base
      def path; Overapp.to_proper_dir(descriptor); end

      def load(base,ops)
        if Overapp::Project.project? path
          Project.new(:descriptor => path).load(base,ops)
        else
          RawDir.new(:descriptor => path).load(base,ops)
        end
      end
    end
  end
end