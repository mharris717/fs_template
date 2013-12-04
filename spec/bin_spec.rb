require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe "bin" do
  include_context "projects"
  include_context "output dir"

  let(:mock_file_methods) { false }

  project "main" do |p|
    p.file "README","hello"
    p.file "rails.png",Overapp.read(File.dirname(__FILE__) + "/input/rails.png")
  end

  before do
    root = File.dirname(__FILE__) + "/.."
    bin = "#{root}/bin/overapp"
    ec "#{bin} #{project.path} #{output_dir}"
  end

  it 'read output' do
    path = output_dir + "/README"
    File.read(path).should == 'hello'
  end
end