module Overapp
  class Var
    fattr(:vars) { {} }
    def set(k,v)
      vars[k.to_s] = v
    end
    def clear!
      self.vars!
    end

    class << self
      fattr(:instance) { new }
      def method_missing(sym,*args,&b)
        instance.send(sym,*args,&b)
      end
    end
  end
end