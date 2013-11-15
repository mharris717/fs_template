module Overapp
  class Git
    class << self
      def commit_inner(output_path,message,init,&b)
        res = nil
        res = yield if block_given?
        if init
          `rm -rf #{output_path}/.git`
          ec "cd #{output_path} && git init && git config user.email johnsmith@fake.com && git config user.name 'John Smith'", :silent => true
        end
        ec "cd #{output_path} && git add . && git commit -m '#{message}'", :silent => true
        res
      end
      def commit(output_path,message,&b)
        init = !FileTest.exist?("#{output_path}/.git")
        commit_inner(output_path,message,init,&b)
      end

      def repo?(path)
        path =~ /\.git/ || path =~ /file:\/\// || path =~ /git:\/\//
      end
    end
  end
end