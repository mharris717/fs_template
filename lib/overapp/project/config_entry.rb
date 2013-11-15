module Overapp
  class ConfigEntry
    include FromHash
    attr_accessor :descriptor, :type, :entry_ops
  end
end