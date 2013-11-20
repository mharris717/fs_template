require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

class MockLoadFactory
  include FromHash
  attr_accessor :descriptor, :type, :entry_ops
  def loader
    OpenStruct.new(:foo => :bar)
  end
end


describe "Command Replacement" do
  describe 'Basic' do
    let(:config_body) do
      "c.overapp :bar"
    end

    let(:project) do
      res = Overapp::Project.new(:path => "/fun")
      res.stub(:config_body) { config_body }
      res.load_factory_class = MockLoadFactory
      res
    end

    it 'size' do
      project.overapps.size.should == 2
    end

    it 'foo' do
      project.overapps.first.foo.should == :bar
    end
  end
end