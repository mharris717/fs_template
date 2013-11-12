require 'mharris_ext'

class Object
  def klass
    self.class
  end
end

module Overapp
  def self.load_files!
    %w(files template_file project from_command).each do |f|
      load File.dirname(__FILE__) + "/overapp/#{f}.rb"
    end

    %w(base command load_dir repo).each do |f|
      load File.dirname(__FILE__) + "/overapp/load/#{f}.rb"
    end

    %w(config write).each do |f|
      load File.dirname(__FILE__) + "/overapp/project/#{f}.rb"
    end

    %w(tmp_dir).each do |f|
      load File.dirname(__FILE__) + "/overapp/util/#{f}.rb"
    end
  end
end

Overapp.load_files!

module Overapp
  class << self
    def with_local_path(overapp_path,&b)
      if overapp_path =~ /git/
        with_repo_path(overapp_path) do |dir|
          b[dir]
        end
      else
        yield overapp_path
      end
    end
    def write_project(overapp_path,output_path)
      with_local_path(overapp_path) do |dir|
        Overapp::Project.new(:path => dir).write_to!(output_path)
      end
    end

    def load_proper_obj(dir)
      if Project.project?(dir)
        Project.new(:path => dir)
      else
        Files.load(dir)
      end
    end

    def ec(cmd,ops={})
      `#{cmd}`
    end
  end
end