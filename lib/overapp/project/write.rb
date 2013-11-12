module Overapp
  class Project
    class Write
      include FromHash
      attr_accessor :output_path, :project

      def commands(phase); project.commands(phase); end
      def base_files; project.base_files; end
      def combined_files; project.combined_files; end
      def config; project.config; end
      def path; project.path; end

      def git_commit(message,init=false)
        if init
          `rm -rf #{output_path}/.git`
          ec "cd #{output_path} && git init && git config user.email johnsmith@fake.com && git config user.name 'John Smith'", :silent => true
        end
        ec "cd #{output_path} && git add . && git commit -m '#{message}'", :silent => true
      end

      def run_commands!(phase)
        commands(phase).each do |cmd|
          Overapp.ec "cd #{output_path} && #{cmd}", :silent => true
          git_commit output_path, "Ran Command: #{cmd}"
        end
      end

      def write!
        run_commands! :before

        base_files.write_to! output_path
        git_commit "Base Files #{config.base}", true

        combined_files.write_to!(output_path)
        git_commit "Overapp Files #{path}"

        run_commands! :after
      end
    end
  end
end