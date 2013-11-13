module Overapp
  module Load
    class Command < Base
      def command; descriptor; end
      def apply_to(base,ops={})
        Overapp.ec "cd #{ops[:path]} && #{command}"
        RawDir.new(:descriptor => ops[:path]).load
      end
    end
  end
end