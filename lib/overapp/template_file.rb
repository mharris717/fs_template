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
      BodyMod.transform(base_body,body,params)
    end

    def apply_body_to(base_body)
      params_obj.inject(base_body) do |new_base_body,params|
        if params[:action].blank?
          templated_body(params)
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
    def parsed
      combined(OpenStruct.new(:full_body => ""))
    end
  end

  class BasicFile < TemplateFile
    def body
      full_body
    end
  end
end