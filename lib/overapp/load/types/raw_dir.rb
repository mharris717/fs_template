module Overapp
  module Load
    class RawDir < Base
      def dir; Overapp.to_proper_dir(descriptor); end
      def load_independent
        ops = {}
        raise "Bad dir" unless dir.present?
        
        res = Files.new
        res.file_class = ops[:file_class] if ops[:file_class]

        Overapp.dir_files_full(dir).each do |f|
          res.add(f)
        end

        res
      end

      def load(base,ops={})
        base.apply(load_independent)
      end
    end
  end
end