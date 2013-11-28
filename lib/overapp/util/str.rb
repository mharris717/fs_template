module Overapp
  class << self
    def split_first(line,delim)
      parts = line.split(delim).select { |x| x.present? }
      if parts.size > 2
        parts = [parts[0],parts[1..-1].join(":")]
      end
      raise "bad #{parts.inspect}" unless parts.size == 2
      parts
    end
  end
end