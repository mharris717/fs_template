module Overapp
  module Load
    class Command < Base
      attr_accessor :relative_output_path
      def command; descriptor; end

      def target_path(dir)
        if relative_output_path.present?
          "#{dir}/#{relative_output_path}"
        else
          dir
        end
      end

      def load(base,ops={})
        base.with_tmp do |dir|
          Overapp.ec "cd #{dir} && #{command}", :silent => true
          RawDir.new(:descriptor => target_path(dir))
        end
      end
    end
  end
end