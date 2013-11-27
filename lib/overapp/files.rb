module Overapp
  class MissingBaseFileError < RuntimeError
    include FromHash
    attr_accessor :top_file, :base
    def message
      res = "Cannot overlay onto missing file #{top_file.path}\nBase File Count: #{base.files.size}\n#{top_file.params_obj.note_params.inspect}"
      res += base.map { |x| x.path }.join("\n")
      res
    end
  end
  class Files
    include FromHash
    include Enumerable
    fattr(:files) { {} }
    fattr(:file_class) { TemplateFile }
    def add(ops)
      if !ops
        raise "no ops"
      elsif ops.kind_of?(Hash)
        if ops[:body]
          file = file_class.new(:path => ops[:file], :full_body => ops[:body])
          self.files[file.path] = file
        else
          self.files.delete(ops[:file])
        end
      else
        self.files[ops.path] = ops
      end
    end
    def size
      files.size
    end

    def apply(on_top,ops={})
      res = self.class.new(:files => files.clone)
      on_top.each do |top_file|
        res.apply_file(top_file,ops)
      end
      res
    end

    def apply_file(top_file,ops={})
      if ops[:vars] && ops[:vars].size > 0
        top_file.vars = ops[:vars]
      end
      existing = files[top_file.path]
      if existing
        new_file = top_file.combined(existing)
        add :file => top_file.path, :body => new_file.andand.body
      elsif top_file.has_note?
        raise MissingBaseFileError.new(:top_file => top_file, :base => self)
      else
        add top_file.parsed
      end
    end


    def each(&b)
      files.values.each(&b)
    end

    def write_to!(dir)
      each do |f|
        f.write_to! dir
      end
      self
    end

    def with_tmp(&b)
      Overapp::TmpDir.with do |dir|
        write_to! dir
        b[dir]
      end
    end
  end
end