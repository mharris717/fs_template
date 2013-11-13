module Overapp
  class Project
    class Write
      include FromHash
      attr_accessor :output_path, :project

      def base_files; project.base_files; end
      def combined_files; project.combined_files; end
      def path; project.path; end

      def write!
        base_files.write_to! output_path
        combined_files.write_to!(output_path)
      end
    end
  end
end