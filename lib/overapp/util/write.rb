module Overapp
  class << self
    def write_project(overapp_path,output_path,vars={})
      Overapp.with_local_path(overapp_path) do |dir|
        project = Overapp::Project.new(:path => dir)
        vars.each { |k,v| project.unloaded_config.vars[k] = v }
        project.write_to!(output_path)
      end
    end
  end
end