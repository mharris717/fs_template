module FsTemplate
  class Files
    include FromHash
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
          res << top_file.combined(existing)
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
      def dir_files(dir)
        res = Dir["#{dir}/**/*"] + Dir["#{dir}/**/.*"]
        res - [".","..",".git"]
      end
      def load_dir(dir)
        raise "Bad dir" unless dir.present?
        raise "Dir not there" unless FileTest.exist?(dir)
        res = new
        dir_files(dir).each do |full_file|
          if FileTest.file?(full_file)
            f = full_file.gsub("#{dir}/","")
            raise "bad #{f}" if f == full_file
            res.add :file => f, :body => File.read(full_file)
          end
        end
        res
      end

      def load(descriptor)
        raise "bad #{descriptor}" if descriptor.blank?
        if descriptor =~ /\.git/
          load_repo(descriptor)
        else
          load_dir(descriptor)
        end
      end

      def write_combined(base_dir, top_dir, output_dir)
        base = load(base_dir)
        top = load(top_dir)
        combined = base.apply(top)
        combined.write_to! output_dir
      end

      def load_repo(url)
        dir = "/tmp/#{rand(1000000000000000000)}"
        ec "git clone #{url} #{dir} 2>&1", :silent => true
        load dir
      ensure
        ec "rm -rf #{dir}", :silent => true
      end
    end
  end
end