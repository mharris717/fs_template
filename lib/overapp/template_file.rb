module Overapp
  class TemplateFile
    include FromHash
    attr_accessor :path, :full_body

    def split_note_and_body
      res = []
      remaining_body = full_body
      while remaining_body
        if remaining_body =~ /^<over(?:lay|app)>(.+)<\/over(?:lay|app)>(.*)(<over(?:lay|app)>.+)/m
          note = $1
          rest = $2
          remaining_body = $3
          res << {:note => note, :body => rest}
        elsif remaining_body =~ /^<over(?:lay|app)>(.+)<\/over(?:lay|app)>(.*)/m
          note = $1
          rest = $2
          remaining_body = nil
          res << {:note => note, :body => rest}
        else
          res << {:note => nil, :body => remaining_body}
          remaining_body = nil
        end
      end
      res
    end


    def note_params_single(one)
      res = {}
      note = one[:note]
      res[:body] = one[:body]

      if note
        lines = note.split("\n").select { |x| x.present? }
        if lines.size == 1 && !(lines.first =~ /action:/)
          res[:action] = lines.first.strip
        else
          lines.each do |line|
            parts = line.split(":").map { |x| x.strip }.select { |x| x.present? }
            raise "bad #{path} #{parts.inspect}" unless parts.size == 2
            res[parts[0].to_sym] = parts[1]
          end
        end
      else
        # do nothing
      end
      res
    end

    def note_params
      split_parts.map do |one|
        note_params_single(one)
      end
    end


    def apply_body_to(base_body)
      note_params.each do |params|
        body = params[:body]
        base_body = if params[:action].blank?
          body
        elsif params[:action] == 'append'
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
        elsif params[:action] == 'delete'
          :delete
        else
          raise "bad #{params.inspect}"
        end
      end
      base_body
    end

    fattr(:split_parts) { split_note_and_body }   

    def body
      full_body
    end 

    def combined(base)
      b = apply_body_to(base.full_body)
      if b == :delete
        nil
      else
        self.class.new(:path => path, :full_body => b)
      end
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