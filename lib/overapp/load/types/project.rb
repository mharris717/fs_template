module Overapp
  module Load
    class Project < Base
      def path; descriptor; end
      def apply_to(base,ops={})
        project = Overapp::Project.new(:path => path)
        project.write_to! ops[:path]
        RawDir.new(:descriptor => ops[:path]).load
      end
    end
  end
end