module Overapp
  module Load
    class Project < Base
      def path; descriptor; end
      def load
        Overapp::Project.new(:path => path).combined_files
      end
    end
  end
end