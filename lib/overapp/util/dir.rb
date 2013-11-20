module Overapp
  class << self
    def dir_files_real(dir)
      res = Dir["#{dir}/**/*"] + Dir["#{dir}/**/.*"]
      res = res - [".","..",".git"]
      res.reject { |x| FileTest.file?(x) && File.binary?(x) && !(x =~ /\.txt/) }
      res.select { |x| FileTest.file?(x) }
      #raise rej.inspect unless rej.empty?
      #res - rej
    end
    def dir_files(dir)
      dir_files_real(dir)
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