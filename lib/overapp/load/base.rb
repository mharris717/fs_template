module Overapp
  module Load
    class Base
      include FromHash
      attr_accessor :descriptor

      def apply(on_top)
        load.apply(on_top)
      end

    end
  end
end