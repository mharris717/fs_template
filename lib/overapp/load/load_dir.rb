module Overapp
  module Load
    class LoadDir < Base
      def dir; descriptor; end
      def load
        raise "Bad dir" unless dir.present?
        raise "Dir not there #{dir}" unless FileTest.exist?(dir)
        res = new
        res.file_class = ops[:file_class] if ops[:file_class]
        dir_files(dir).each do |full_file|
          if FileTest.file?(full_file)
            f = full_file.gsub("#{dir}/","")
            raise "bad #{f}" if f == full_file
            res.add :file => f, :body => File.read(full_file)
          end
        end
        res
      end
    end
  end
end