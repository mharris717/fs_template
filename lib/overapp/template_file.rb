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
    rescue => exp
      puts "Error in split_note_and_body #{path}"
      raise exp
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
            parts = line.split(":").select { |x| x.present? }
            if parts.size > 2
              parts = [parts[0],parts[1..-1].join(":")]
            end
            parts = parts.map { |x| x.strip }
            raise "bad #{path} #{parts.inspect}" unless parts.size == 2
            res[parts[0].to_sym] = parts[1]
          end
        end
      end
      res
    end

    def note_params
      split_parts.map do |one|
        note_params_single(one)
      end
    end

    def templated_body(params)
      body = params[:body]
      if params[:template] == 'erb'
        require 'erb'
        erb = ERB.new(body)
        body = erb.result
      end
      body
    end

    def body_after_action(base_body,params)
      body = templated_body(params)

      res = if params[:action] == 'append'
        base_body + body
      elsif params[:action] == 'insert' && params[:after]
        base_body.gsub(params[:after],"#{params[:after]}#{body}")
      elsif params[:action] == 'insert' && params[:before]
        base_body.gsub(params[:before],"#{body}#{params[:before]}")
      elsif params[:action] == 'replace' && params[:base]
        base_body.gsub(params[:base],body)
      elsif params[:action] == 'delete'
        :delete
      else
        raise "bad #{params.inspect}"
      end
      raise ["no change",params.inspect,body,base_body].join("\n") if res == base_body
      res
    end


    def apply_body_to(base_body)
      note_params.inject(base_body) do |new_base_body,params|
        if params[:action].blank?
          params[:body]
        elsif params[:action]
          body_after_action(new_base_body,params)
        else
          raise "bad"
        end
      end
    end

    fattr(:split_parts) { split_note_and_body }   
    def has_note?
      split_parts.any? { |x| x[:note].present? }
    end

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