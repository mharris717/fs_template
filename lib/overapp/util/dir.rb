module Overapp
  class << self
    def dir_files(dir)
      res = Dir["#{dir}/**/*"] + Dir["#{dir}/**/.*"]
      res = res - [".","..",".git"]
      res = res.select { |x| FileTest.file?(x) }
      res.reject { |x| File.binary?(x) && !(x =~ /\.txt/) }
    end
    def dir_files_full(dir)
      raise "Dir not there #{dir}" unless FileTest.exist?(dir)
      dir_files(dir).map do |full_file|
        f = full_file.gsub("#{dir}/","")
        raise "bad #{f}" if f == full_file
        {:file => f, :body => File.read(full_file)}
      end
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