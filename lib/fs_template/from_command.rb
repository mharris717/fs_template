module FsTemplate
  class FromCommand
    include FromHash
    attr_accessor :command, :path

    def with_tmp_dir
      dir = "/tmp/#{rand(1000000000000000000)}"
      `mkdir #{dir}`
      Dir.chdir(dir) do
        yield dir
      end
    ensure
      ec "rm -rf #{dir}", :silent => true
    end

    fattr(:files) do
      with_tmp_dir do |dir|
        FsTemplate.ec command, :silent => true
        Files.load [dir,path].select { |x| x.present? }.join("/"), :file_class => BasicFile
      end
    end
  end
end