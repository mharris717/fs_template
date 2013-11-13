module Overapp
  class Project
    include FromHash
    attr_accessor :path

    class << self
      def project_files
        %w(.fstemplate .overapp .overlay)
      end

      def project?(path)
        !!project_files.map { |x| "#{path}/#{x}" }.find { |x| FileTest.exist?(x) }
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
  end
end