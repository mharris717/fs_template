module Overapp
  class Project
    include FromHash
    attr_accessor :path
    fattr(:vars) { config.vars }
    def add_vars(vs)
      vs.each do |k,v|
        unloaded_config[k] = v
      end
    end

    class << self
      def project_files
        %w(.fstemplate .overapp .overlay)
      end

      def project?(path)
        raise "checking for project, path doesn't exist #{path}" unless FileTest.exist?(path)
        !!project_files.map { |x| "#{path}/#{x}" }.find { |x| FileTest.exist?(x) }
      end

      def load(ops={})
        if ops[:path] && FileTest.file?(ops[:path])
          BareProject.new(ops)
        else
          new(ops)
        end
      end
    end

    fattr(:config_body) do
      file = klass.project_files.map { |x| "#{path}/#{x}" }.find { |x| FileTest.exist?(x) }
      if file
        File.read(file)
      else
        raise "no config found in #{path}"
      end
    end

    fattr(:unloaded_config) do
      res = ProjectConfig.new
      res.body = config_body
      res
    end

    fattr(:config) do
      unloaded_config.load!
      unloaded_config
    end

    def reload_config!
      config_body!
      unloaded_config!
      config!
    end

    def overapp_entries
      res = config.overapps

      local = config.overapps.find { |x| ['.',:self,path].include?(x.descriptor) }
      res = if local
        local.descriptor = path
        res
      else
        res + (use_local? ? [ConfigEntry.new(:descriptor => path)] : [])
      end

      res.reject { |x| x.ignore? }
    end

    def use_local?
      true
    end

    fattr(:load_factory_class) { Load::Factory }
    fattr(:load_raw_dir_class) { Load::RawDir }

    def overapps
      overapp_entries.map do |entry|
        if path == entry.descriptor
          load_raw_dir_class.new(:descriptor => path)
        else
          load_factory_class.new(:descriptor => entry.descriptor, :type => entry.type, :entry_ops => entry.entry_ops).loader
        end
      end
    end

    def write_to!(output_path)
      Write.new(:output_path => output_path, :project => self).write!
    end

    def combined_files
      Write.new(:project => self).combined_files
    end
  end

  class BareProject < Project
    fattr(:config_body) do
      File.read(path)
    end
    def use_local?
      false
    end
  end
end