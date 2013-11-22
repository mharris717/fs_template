module Overapp
  class TemplateFile
    class VarObj
      include FromHash
      attr_accessor :file

      def method_missing(sym,*args,&b)
        if file.vars.has_key?(sym)
          file.vars[sym]
        elsif file.vars.has_key?(sym.to_s)
          file.vars[sym.to_s]
        else
          raise "not found #{sym}, options are #{file.vars.inspect}"
        end
      end

      def render(body)
        require 'erb'
        erb = ERB.new(body)
        erb.result(binding)
      end
    end
  end
end