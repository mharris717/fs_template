module Overapp
  module Load
    class Command < Base
      def command; descriptor; end
      def load(base,ops={})
        Overapp.ec "cd #{ops[:path]} && #{command}", :silent => true
        RawDir.new(:descriptor => ops[:path]).load(base,ops)
      end
    end
  end
end