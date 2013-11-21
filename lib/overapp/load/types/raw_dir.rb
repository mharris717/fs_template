module Overapp
  module Load
    class RawDir < Base
      def dir; Overapp.to_proper_dir(descriptor); end
      def load_independent
        ops = {}
        raise "Bad dir" unless dir.present?
        raise "Dir not there #{dir}" unless FileTest.exist?(dir)
        res = Files.new
        res.file_class = ops[:file_class] if ops[:file_class]
        Overapp.dir_files(dir).each do |full_file|
          f = full_file.gsub("#{dir}/","")
          raise "bad #{f}" if f == full_file
          res.add :file => f, :body => File.read(full_file)
        end
        res
      end

      def load(base,ops={})
        base.apply(load_independent)
      end
    end
  end
end