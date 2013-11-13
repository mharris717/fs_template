module Overapp
  module Load
    class Base
      include FromHash
      attr_accessor :descriptor

      def apply_to(base,ops)
        base.apply(load)
      end

      def commit_message
        "Message Pending #{id}"
      end
    end
  end
end