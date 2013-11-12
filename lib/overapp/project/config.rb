module Overapp
  class ProjectConfig
    include FromHash
    attr_accessor :body, :base, :base_ops
    fattr(:overapps) { [] }
    fattr(:commands) { [] }

    def base(*args)
      if args.empty?
        @base
      else
        @base = args.first
        @base_ops = args[1] || {}
      end
    end

    def overapp(name)
      self.overapps << name
    end

    def overlay(name)
      overapp(name)
    end

    def command(cmd,phase=:after)
      self.commands << {:command => cmd, :phase => phase}
    end

    def load!
      c = self
      eval(body)
    end
  end
end