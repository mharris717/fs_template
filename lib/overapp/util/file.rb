module Overapp
  class << self
    def file_create(*args)
      File.create(*args)
    end
  end
end