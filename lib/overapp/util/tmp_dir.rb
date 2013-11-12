module Overapp
  class TmpDir
    def self.with(ops={})
      dir = "/tmp/#{rand(1000000000000000000)}"
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
        ec "rm -rf #{dir}", :silent => true
      end
    end

    def self.with_repo_path(url)
      with do |dir|
        `git clone #{url} .`
        yield dir
      end
    end
  end
end