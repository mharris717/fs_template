require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe 'Git Coverage' do
  it 'smoke' do
    Overapp::TmpDir.with do |dir|
      Overapp::Git.commit(dir,"stuff") do
        File.create "#{dir}/abc.txt","hello"
      end
    end
    2.should == 2
  end
end

describe 'overapp output is checked into git' do
  before do
    Overapp.stub(:file_create) { |*args| }
    Overapp.stub(:ec) { |*args| }
  end

  include_context "projects"

  project do |p|
    p.file "README","Hello"
  end

  let(:output_path) do
    "/tmp/asdfsfwefwef/fgdfgeefgefgefge#{rand(100000000000000)}"
  end

  it 'write' do
    Overapp::Git.should_receive(:commit_inner).with(output_path,"Overlay Created",true)
    project.write_to! output_path
  end
end