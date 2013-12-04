require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe "bare project" do
  include_context "tmp dir"

  before do
    File.create config_path,config_body
  end

  let(:config_body) do
    "c.overapp 'foo'"
  end

  let(:config_path) do
    "#{tmp_dir}/overlay_config.rb"
  end

  let(:project) do
    Overapp::Project.load(:path => config_path)
  end

  it 'body' do
    project.config_body.should == config_body
  end

  it 'overapp count' do
    project.overapps.size.should == 1
  end
end