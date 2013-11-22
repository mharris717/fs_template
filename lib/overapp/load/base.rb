module Overapp
  module Load
    class Base
      include FromHash
      attr_accessor :descriptor

      def initialize(ops={})
        raise "no descriptor" unless ops[:descriptor].present?
        from_hash(ops)
      end

      def commit_message
        "Message Pending"
      end

      def load_full(base,ops={})
        res = load(base,ops)
        while res.kind_of?(Overapp::Load::Base)
          res = res.load(base,ops)
        end
        res
      end
    end
  end
end