module Overapp
  class << self
    def dir_files(dir)
      res = Dir["#{dir}/**/*"] + Dir["#{dir}/**/.*"]
      res = res - [".","..",".git"]
      rej = res.select { |x| FileTest.file?(x) && File.binary?(x) && !(x =~ /\.txt/) }
      raise rej.inspect unless rej.empty?
      res
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

    def to_proper_dir(dir)
      base = File.expand_path(File.dirname(__FILE__) + "/../../..")
      dir.gsub("OVERAPP_ROOT_DIR",base)
    end
  end
end