require 'mharris_ext'

%w(files template_file thor_file project from_command).each do |f|
  load File.dirname(__FILE__) + "/fs_template/#{f}.rb"
end

module FsTemplate
  class << self
    def with_repo_path(url)
      dir = "/tmp/#{rand(100000000000000000000)}"
      `mkdir #{dir}`
      Dir.chdir(dir) do
        `git clone #{url} .`
      end
      yield dir
    ensure
      `rm -rf #{dir}`
    end
    def with_local_path(overlay_path,&b)
      if overlay_path =~ /git/
        with_repo_path(overlay_path) do |dir|
          b[dir]
        end
      else
        yield overlay_path
      end
    end
    def write_project(overlay_path,output_path)
      with_local_path(overlay_path) do |dir|
        FsTemplate::Project.new(:path => dir).write_to!(output_path)
      end
    end

    def ec(cmd,ops={})
      `#{cmd}`
    end
  end
end