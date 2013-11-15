module Overapp
  module Load
    class Base
      include FromHash
      attr_accessor :descriptor

      def apply_to(base,ops)
        base.apply(load(base,ops))
      end

      def commit_message
        "Message Pending"
      end

      def load(*args)
        raise "load unimplemented"
      end
    end
  end
end