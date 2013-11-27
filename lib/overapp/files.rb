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
      ops = file_class.new(:path => ops[:file], :full_body => ops[:body]) if ops.kind_of?(Hash)
      self.files[ops.path] = ops
    end
    def delete(path)
      self.files.delete(path)
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
      raise MissingBaseFileError.new(:top_file => top_file, :base => self) if !existing && top_file.has_note?
      new_file = top_file.combined(existing)
      if new_file
        add new_file
      else
        delete top_file.path
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