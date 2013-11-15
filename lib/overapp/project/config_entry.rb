module Overapp
  class ConfigEntry
    include FromHash
    attr_accessor :descriptor, :type
  end
end