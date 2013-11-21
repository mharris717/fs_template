module Overapp
  class TmpDir
    class << self
      def base_dir
        File.expand_path(File.dirname(__FILE__) + "/../../../tmp")
      end
      def with(ops={})
        dir = "#{base_dir}/#{rand(1000000000000000000)}"
        `mkdir #{dir}`
        if block_given?
          Dir.chdir(dir) do
            yield dir
          end
        else
          dir
        end
      ensure
        if block_given?
          #ec "rm -rf #{dir}", :silent => true
        end
      end

      def local_repo_map
        res = {}
        res["https://github.com/mharris717/ember_auth_rails_overlay.git"] = "ember_auth_rails_overlay"
        res["https://github.com/mharris717/widget_overlay_rails.git"] = "rails_widget"
        res
      end

      def to_local_repo_path(url)
        base = local_repo_map[url]
        raise "no base #{url}" unless base
        "/code/orig/ember_npm_projects/overlays/#{base}"
      end

      def with_repo_path(url)
        url = Overapp.to_proper_dir(url)
        with do |dir|
          `git clone #{url} . 2>&1`
          yield dir
        end
      end

      def with_repo_path_localuse(url)
        File.create "/code/orig/overapp/repo.txt",url
        dir = to_local_repo_path(url)
        Dir.chdir(dir) do
          yield dir
        end
      end
    end
  end
end