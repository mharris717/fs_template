require 'mharris_ext'

module FsTemplate
  class Files
    include FromHash
    fattr(:files) { [] }
    def add(ops)
      files << TemplateFile.new(:path => ops[:file], :full_body => ops[:body])
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
      def load(dir)
        res = new
        Dir["#{dir}/**/*.*"].each do |full_file|
          f = full_file.gsub("#{dir}/","")
          raise "bad #{f}" if f == full_file
          res.add :file => f, :body => File.read(full_file)
        end
        res
      end

      def write_combined(base_dir, top_dir, output_dir)
        base = load(base_dir)
        top = load(top_dir)
        combined = base.apply(top)
        combined.write_to! output_dir
      end
    end
  end

  class TemplateFile
    include FromHash
    attr_accessor :path, :full_body

    fattr(:split_note_and_body) do
      if full_body =~ /^FSTMODE:([a-z:0-9]+)\s/m
        note = $1
        rest = full_body.gsub(/^FSTMODE:#{note}/,"")
        {:note => note, :body => rest}
      else
        {:note => nil, :body => full_body}
      end
    end

    fattr(:body) { split_note_and_body[:body] }
    fattr(:note) { split_note_and_body[:note] }

    def apply_body_to(base_body)
      note_parts = note.to_s.split(":")
      if note == 'append'
        base_body + body
      elsif note_parts[0] == 'insert'
        raise "bad" unless note_parts[1] == 'line'
        base_lines = base_body.split("\n")
        i = note_parts[2].to_i - 1
        base_lines[0...i].join("\n") + body + base_lines[i..-1].join("\n")
      elsif note.nil?
        body
      else
        raise "unknown note #{note}"
      end
    end

    def combined(base)
      self.class.new(:path => path, :full_body => apply_body_to(base.body))
    end

    def write_to!(dir)
      raise "bad path" if path.blank?
      d = File.dirname("#{dir}/#{path}")
      `mkdir -p #{d}`
      File.create "#{dir}/#{path}",body
    end
  end
end