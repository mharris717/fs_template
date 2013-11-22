module Overapp
  class TemplateFile
    class BodyMod
      class Single
        include FromHash
        attr_accessor :match, :transform
        def match?(params)
          match[params]
        end
      end

      class List
        fattr(:list) { [] }
        def register(match_proc, transform_proc)
          self.list << Single.new(match: match_proc, transform: transform_proc)
        end

        def transform(base_body,body,params)
          single = list.find { |x| x.match?(params) }
          raise "bad #{params.inspect}" unless single
          res = single.transform[base_body,body,params]
          raise "no change" if res == base_body
          res
        end
      end

      class << self
        def register(*args)
          instance.register(*args)
        end
        def transform(*args)
          instance.transform(*args)
        end
        fattr(:instance) { List.new }
      end


      register lambda { |params| params[:action] == 'append' }, 
               lambda { |base_body,body,params| base_body + body }

      register lambda { |params| params[:action] == 'insert' && params[:after] }, 
               lambda { |base_body,body,params| base_body.gsub(params[:after],"#{params[:after]}#{body}") }  

      register lambda { |params| params[:action] == 'insert' && params[:before] }, 
               lambda { |base_body,body,params| base_body.gsub(params[:before],"#{body}#{params[:before]}") }  

      register lambda { |params| params[:action] == 'replace' && params[:base] }, 
               lambda { |base_body,body,params| base_body.gsub(params[:base],body) }  

      register lambda { |params| params[:action] == 'delete' }, 
               lambda { |base_body,body,params| :delete }  

     
    end
  end
end