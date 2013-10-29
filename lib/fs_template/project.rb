module FsTemplate
  class Project
    include FromHash
    attr_accessor :path

    def config_body
      if FileTest.exist?("#{path}/.fstemplate")
        File.read("#{path}/.fstemplate")
      elsif FileTest.exist?("#{path}/.overlay")
        File.read("#{path}/.overlay")
      else
        raise "no config"
      end
    end

    fattr(:config) do
      res = ProjectConfig.new
      res.body = config_body
      res.load!
      res
    end

    def overlay_paths
      config.overlays + [path]
    end

    fattr(:overlays) do
      overlay_paths.map { |x| Files.load(x) }
    end

    fattr(:base_files) do
      Files.load(config.base)
    end

    fattr(:combined_files) do
      res = base_files
      overlays.each do |overlay|
        res = res.apply(overlay)
      end
      res
    end

    def write_to!(output_path)
      base_files.write_to! output_path
      `rm -rf #{output_path}/.git`

      full_init = 'git init && git config user.email johnsmith@fake.com && git config user.name "John Smith"'
      ec "cd #{output_path} && #{full_init} && git add . && git commit -m 'Base Files #{config.base}'", :silent => true
      combined_files.write_to!(output_path)
      ec "cd #{output_path} && git add . && git commit -m 'Overlay Files #{path}'", :silent => true
    end
  end

  class ProjectConfig
    include FromHash
    attr_accessor :body, :base
    fattr(:overlays) { [] }

    def base(*args)
      if args.empty?
        @base
      else
        @base = args.first
      end
    end

    def overlay(name)
      self.overlays << name
    end

    def load!
      c = self
      eval(body)
    end
  end
end