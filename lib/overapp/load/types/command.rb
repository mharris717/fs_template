module Overapp
  module Load
    class Command < Base
      attr_accessor :relative_output_path
      def command; descriptor; end
      def load(base,ops={})
        if relative_output_path.present?
          TmpDir.with do |dir|
            Overapp.ec "cd #{dir} && #{command}", :silent => false
            RawDir.new(:descriptor => "#{dir}/#{relative_output_path}").load(base,ops)
          end
        else
          Overapp.ec "cd #{ops[:path]} && #{command}", :silent => false
          RawDir.new(:descriptor => ops[:path]).load(base,ops)
        end
      end
    end
  end
end