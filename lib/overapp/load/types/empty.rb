module Overapp
  module Load
    class Empty
      def load(base,ops)
        Overapp::Files.new
      end
      def needs_write?
        false
      end
    end
  end
end