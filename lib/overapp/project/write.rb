module Overapp
  class Project
    class Write
      include FromHash
      attr_accessor :output_path, :project

      fattr(:instance) do
        Load::Instance.new(:overlays => project.overapps, :vars => Overapp::Var.vars.merge(project.vars))
      end

      def combined_files
        instance.combined_files
      end

      def write!
        raise "no combined files" unless combined_files
        Overapp::Git.commit(output_path,"Overlay Created") do
          combined_files.write_to!(output_path)
        end
      end
    end
  end
end