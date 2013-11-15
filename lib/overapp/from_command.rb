module Overapp
  class FromCommand
    include FromHash
    attr_accessor :command, :path

    fattr(:files) do
      Overapp.with_tmp_dir do |dir|
        Overapp.ec command, :silent => true
        Files.load [dir,path].select { |x| x.present? }.join("/"), :file_class => BasicFile
      end
    end
  end
end