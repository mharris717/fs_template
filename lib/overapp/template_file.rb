module Overapp
  class TemplateFile
    include FromHash
    attr_accessor :path, :full_body

    fattr(:params_obj) do
      Params.new(:full_body => full_body)
    end

    def has_note?
      params_obj.has_note?
    end

    class VarObj
      include FromHash
      attr_accessor :file

      def method_missing(sym,*args,&b)
        if file.vars.has_key?(sym)
          file.vars[sym]
        else
          raise "not found #{sym}"
        end
      end

      def render(body)
        require 'erb'
        erb = ERB.new(body)
        erb.result(binding)
      end
    end

    def templated_body(params)
      body = params[:body]
      if params[:template] == 'erb'
        v = VarObj.new(:file => self)
        body = v.render(body)
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
      params_obj.inject(base_body) do |new_base_body,params|
        if params[:action].blank?
          params[:body]
        elsif params[:action]
          body_after_action(new_base_body,params)
        else
          raise "bad"
        end
      end
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

    fattr(:vars) { {} }
  end

  class BasicFile < TemplateFile
    def body
      full_body
    end
  end
end