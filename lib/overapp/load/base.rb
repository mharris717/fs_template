module Overapp
  module Load
    class Base
      include FromHash
      attr_accessor :descriptor

      def initialize(ops={})
        raise "no descriptor" unless ops[:descriptor].present?
        from_hash(ops)
      end

      def apply_to(base,ops)
        base.apply(load_full(base,ops))
      end

      def commit_message
        "Message Pending"
      end

      def load(*args)
        raise "load unimplemented"
      end

      def load_outer(base,ops={})
        load(base,ops)
      end

      def load_full(base,ops={})
        res = load_outer(base,ops)
        while res.kind_of?(Overapp::Load::Base)
          res = res.load_outer(base,ops)
        end
        #puts "load on #{self.class}, old size #{base.size}, new size #{res.size}"
        res
      end
    end
  end
end