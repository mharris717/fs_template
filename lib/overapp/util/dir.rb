module Overapp
  class << self
    def dir_files(dir)
      res = Dir["#{dir}/**/*"] + Dir["#{dir}/**/.*"]
      res - [".","..",".git"]
    end

    def with_local_path(overapp_path,&b)
      if Git.repo?(overapp_path)
        TmpDir.with_repo_path(overapp_path) do |dir|
          b[dir]
        end
      else
        yield overapp_path
      end
    end
  end
end