module Overapp
  class MissingBaseFileError < RuntimeError
    include FromHash
    attr_accessor :top_file, :base
    def message
      res = "Cannot overlay onto missing file #{top_file.path}\nBase File Count: #{base.files.size}\n"
      res += base.map { |x| x.path }.join("\n")
      res
    end
  end
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
          raise MissingBaseFileError.new(:top_file => top_file, :base => self)
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
      self
    end

    class << self
      def load_command(cmd,ops)
        FromCommand.new(:command => cmd, :path => ops[:path]||".").files
      end
    end
  end
end