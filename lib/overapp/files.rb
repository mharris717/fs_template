module Overapp
  class Files
    include FromHash
    include Enumerable
    fattr(:files) { [] }
    fattr(:file_class) { TemplateFile }
    def add(ops)
      files << file_class.new(:path => ops[:file], :full_body => ops[:body])
    end
    def size
      files.size
    end
    def apply(on_top)
      res = files.clone
      on_top.each do |top_file|
        existing = res.find { |x| x.path == top_file.path }
        if existing
          res -= [existing]
          new_file = top_file.combined(existing)
          res << new_file if new_file
        elsif top_file.has_note?
          raise "cannot overlay onto missing file #{top_file.path}"
        else
          res << top_file
        end
      end
      self.class.new(:files => res)
    end
    def each(&b)
      files.each(&b)
    end

    def write_to!(dir)
      each do |f|
        f.write_to! dir
      end
    end

    class << self
      def load_command(cmd,ops)
        FromCommand.new(:command => cmd, :path => ops[:path]||".").files
      end
    end
  end
end