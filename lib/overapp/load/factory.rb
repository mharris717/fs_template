module Overapp
  module Load
    class Factory
      include FromHash
      attr_accessor :descriptor, :type

      def loader
        raise "bad #{descriptor}" if descriptor.blank?
        if type.to_s.to_sym == :command
          Command.new(:descriptor => descriptor)
        elsif Git.repo?(descriptor)
          Repo.new(:descriptor => descriptor)
        else
          LocalDir.new(:descriptor => descriptor)
        end
      end
    end
  end
end