module Overapp
  class Project
    class Write
      include FromHash
      attr_accessor :output_path, :project

      def instance
        Load::Instance.new(:path => output_path, :overlays => project.overapps)
      end

      def combined_files
        instance.combined_files
      end

      def write!
        combined_files.write_to!(output_path)
      end
    end
  end
end