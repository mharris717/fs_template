module Overapp
  module Load
    class Repo < Base
      def url; descriptor; end
      def load
        url = url.gsub "ROOT_DIR", File.expand_path(File.dirname(__FILE__) + "/../..")
        dir = "/tmp/#{rand(1000000000000000000)}"
        ec "git clone #{url} #{dir} 2>&1", :silent => true
        LoadDir.new(:path => dir).load
      ensure
        ec "rm -rf #{dir}", :silent => true
      end
    end
  end
end