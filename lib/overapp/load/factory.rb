module Overapp
  module Load
    class Factory
      include FromHash
      attr_accessor :descriptor, :type, :entry_ops

      def loader
        raise "bad #{descriptor}" if descriptor.blank?
        if type.to_s.to_sym == :command
          Command.new(:descriptor => descriptor).tap { |x| x.relative_output_path = entry_ops[:path] if entry_ops[:path].present? }
        elsif Git.repo?(descriptor)
          Repo.new(:descriptor => descriptor)
        else
          LocalDir.new(:descriptor => descriptor)
        end
      end
    end
  end
end