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

    def overapp_entries
      config.overapps + [ConfigEntry.new(:descriptor => path)]
    end

    def overapps
      overapp_entries.map do |entry|
        if path == entry.descriptor
          Load::RawDir.new(:descriptor => path)
        else
          Load::Factory.new(:descriptor => entry.descriptor, :type => entry.type).loader
        end
      end
    end

    def write_to!(output_path)
      Write.new(:output_path => output_path, :project => self).write!
    end

    def combined_files(output_path)
      raise 'here'
      Write.new(:output_path => output_path, :project => self).combined_files
    end
  end
end