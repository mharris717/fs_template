module Overapp
  class << self
    def write_project(overapp_path,output_path)
      Dir.with_local_path(overapp_path) do |dir|
        Overapp::Project.new(:path => dir).write_to!(output_path)
      end
    end
  end
end