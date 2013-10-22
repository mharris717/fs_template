require 'mharris_ext'

%w(files template_file thor_file project).each do |f|
  load File.dirname(__FILE__) + "/fs_template/#{f}.rb"
end

module FsTemplate
  class << self
    def write_project(overlay_path,output_path)
      FsTemplate::Project.new(:path => overlay_path).write_to!(output_path)
    end
  end
end