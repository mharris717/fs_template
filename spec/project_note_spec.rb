require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe "ProjectConfig" do
  let(:config_body) do
    "c.base :foo"
  end

  let(:config) do
    res = FsTemplate::ProjectConfig.new
    res.body = config_body
    res
  end

  it 'smoke' do
    config.should be
  end

  it 'eval' do
    config.load!
    config.base.should == :foo
  end

end