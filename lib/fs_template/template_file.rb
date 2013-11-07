module FsTemplate
  class TemplateFile
    include FromHash
    attr_accessor :path, :full_body

    module NewWay
      def split_note_and_body_long
        if full_body =~ /<overlay>(.+)<\/overlay>/m
          note = $1
          rest = full_body.gsub(/<overlay>.+<\/overlay>/m,"")
          {:note => note, :body => rest, :format => :long}
        else
          nil
        end
      end

      def note_params
        res = {}
        lines = note.split("\n").select { |x| x.present? }
        if lines.size == 1
          res[:action] = lines.first.strip
        else
          lines.each do |line|
            parts = line.split(":").map { |x| x.strip }.select { |x| x.present? }
            raise "bad #{path} #{parts.inspect}" unless parts.size == 2
            res[parts[0].to_sym] = parts[1]
          end
        end
        res
      end


      def apply_body_to_long(base_body)
        params = note_params
        if note == 'append'
          base_body + body
        elsif params[:action] == 'insert' && params[:after]
          base_body.gsub(params[:after],"#{params[:after]}#{body}").tap do |subbed|
            if subbed == base_body
              raise "no change, couldn't find #{params[:after]} in \n#{base_body}"
            end
          end
        elsif params[:action] == 'insert' && params[:before]
          base_body.gsub(params[:before],"#{body}#{params[:before]}").tap do |subbed|
            if subbed == base_body
              raise "no change, couldn't find #{params[:before]} in \n#{base_body}"
            end
          end
        elsif params[:action] == 'replace' && params[:base]
          base_body.gsub(params[:base],body).tap do |subbed|
            if subbed == base_body
              raise "no change, couldn't find #{params[:base]} in \n#{base_body}"
            end
          end
        else
          raise "bad"
        end
      end
    end

    module OldWay
      def split_note_and_body_short
        if full_body =~ /^FSTMODE:([a-z:0-9]+)\s/m
          note = $1
          rest = full_body.gsub(/^FSTMODE:#{note}/,"")
          {:note => note, :body => rest, :format => :short}
        else
          nil
        end
      end

      def apply_body_to_short(base_body)
        note_parts = note.to_s.split(":")
        if note == 'append'
          base_body + body
        elsif note_parts[0] == 'insert'
          raise "bad" unless note_parts[1] == 'line'
          base_lines = base_body.split("\n")
          i = note_parts[2].to_i - 1
          base_lines[0...i].join("\n") + body + base_lines[i..-1].join("\n")
        else
          raise "unknown note #{note}"
        end
      end
    end

    include OldWay
    include NewWay

    def split_note_and_body
      [:split_note_and_body_short,:split_note_and_body_long].each do |meth|
        res = send(meth)
        return res if res
      end
      {:note => nil, :body => full_body}
    end

    fattr(:split_parts) { split_note_and_body }

    fattr(:body) { split_parts[:body] }
    fattr(:note) { split_parts[:note] }
    fattr(:format) { split_parts[:format] }

    def apply_body_to(base_body)
      if note.present?
        m = "apply_body_to_#{format}"
        send(m,base_body)
      else
        body
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

  class BasicFile < TemplateFile
    def body
      full_body
    end
  end
end