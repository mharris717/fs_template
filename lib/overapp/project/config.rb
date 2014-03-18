module Overapp
  class ProjectConfig
    include FromHash
    attr_accessor :body, :base_ops
    fattr(:overapps) { [] }
    fattr(:vars) { {} }

    def base(*args)
      overapp(*args)
    end

    def overapp(name,ops={})
      self.overapps << ConfigEntry.new(:descriptor => name, :type => :overapp, :entry_ops => ops)
    end

    def overlay(*args)
      overapp(*args)
    end

    def command(cmd,ops={})
      self.overapps << ConfigEntry.new(:descriptor => cmd, :type => :command, :entry_ops => ops)
    end

    def var(k,*args)
      if args.empty?
        vars[k]
      elsif args.size == 1
        vars[k] = args.first
      else
        raise "bad #{args.inspect}"
      end
    end

    def load!
      c = self
      eval(body)
    end
  end
end