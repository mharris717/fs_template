module Overapp
  class ConfigEntry
    include FromHash
    attr_accessor :descriptor, :type, :entry_ops

    def ignore?
      !!(entry_ops||{})[:ignore]
    end
  end
end