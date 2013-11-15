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
          ec "rm -rf #{dir}", :silent => true
        end
      end

      def with_repo_path(url)
        url = Overapp.to_proper_dir(url)
        with do |dir|
          `git clone #{url} . 2>&1`
          yield dir
        end
      end
    end
  end
end