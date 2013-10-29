module FsTemplate
  class Project
    include FromHash
    attr_accessor :path

    fattr(:config) do
      res = ProjectConfig.new
      if FileTest.exist?("#{path}/.fstemplate")
        res.body = File.read("#{path}/.fstemplate")
        res.load!
      elsif FileTest.exist?("#{path}/.overlay")
        res.body = File.read("#{path}/.overlay")
        res.load!
      else
        raise "no config"
      end
      res
    end

    fattr(:overlay_files) do
      Files.load(path)
    end

    fattr(:base_files) do
      Files.load_repo(config.base)
    end

    fattr(:combined_files) do
      base_files.apply(overlay_files)
    end

    def write_to!(output_path)
      base_files.write_to! output_path
      `rm -rf #{output_path}/.git`
      ec "cd #{output_path} && git init && git add . && git commit -m 'Base Files #{config.base}'", :silent => true
      combined_files.write_to!(output_path)
      ec "cd #{output_path} && git add . && git commit -m 'Overlay Files #{path}'", :silent => true
    end
  end

  class ProjectConfig
    include FromHash
    attr_accessor :body, :base

    def base(*args)
      if args.empty?
        @base
      else
        @base = args.first
      end
    end

    def load!
      c = self
      eval(body)
    end
  end
end