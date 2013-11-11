module Overapp
  class Project
    include FromHash
    attr_accessor :path

    class << self
      def project_files
        %w(.fstemplate .overapp .overlay)
      end
    end

    def config_body
      file = klass.project_files.map { |x| "#{path}/#{x}" }.find { |x| FileTest.exist?(x) }
      if file
        File.read(file)
      else
        raise "no config found in #{path}"
      end
    end

    fattr(:config) do
      res = ProjectConfig.new
      res.body = config_body
      res.load!
      res
    end

    def overapp_paths
      config.overapps + [path]
    end

    def commands(phase)
      config.commands.select { |x| x[:phase] == phase }.map { |x| x[:command] }
    end

    fattr(:overapps) do
      overapp_paths.map { |x| Files.load(x) }
    end

    fattr(:base_files) do
      if config.base
        Files.load(config.base,config.base_ops)
      else
        nil
      end
    end

    fattr(:combined_files) do
      res = base_files
      overapps.each do |overapp|
        res = res.apply(overapp)
      end
      res
    end

    def write_to!(output_path)
      Write.new(:output_path => output_path, :project => self).write!
    end

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

  class ProjectConfig
    include FromHash
    attr_accessor :body, :base, :base_ops
    fattr(:overapps) { [] }
    fattr(:commands) { [] }

    def base(*args)
      if args.empty?
        @base
      else
        @base = args.first
        @base_ops = args[1] || {}
      end
    end

    def overapp(name)
      self.overapps << name
    end

    def overlay(name)
      overapp(name)
    end

    def command(cmd,phase=:after)
      self.commands << {:command => cmd, :phase => phase}
    end

    def load!
      c = self
      eval(body)
    end
  end
end