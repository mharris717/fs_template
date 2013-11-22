module Overapp
  module Load
    class Project < Base
      def path; descriptor; end
      fattr(:project) do
        Overapp::Project.load(:path => path)
      end
      def load(base,ops={})
        instance = Load::Instance.new(:overlays => project.overapps, :starting_files => base)
        instance.combined_files
      end
    end
  end
end