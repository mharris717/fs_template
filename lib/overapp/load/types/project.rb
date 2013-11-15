module Overapp
  module Load
    class Project < Base
      def path; descriptor; end
      def load(base,ops={})
        project = Overapp::Project.new(:path => path)
        project.write_to! ops[:path]
        RawDir.new(:descriptor => ops[:path]).load(base,ops)
      end
    end
  end
end