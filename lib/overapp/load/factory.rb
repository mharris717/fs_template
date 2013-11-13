module Overapp
  module Load
    class Factory
      include FromHash
      attr_accessor :descriptor, :type

      def loader
        raise "bad #{descriptor}" if descriptor.blank?
        if type == :command
          raise "command not implemented"
        elsif Git.repo?(descriptor)
          Repo.new(:descriptor => descriptor)
        else
          LocalDir.new(:descriptor => descriptor)
        end
      end
    end
  end
end