require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe 'FromCommand' do
  include_context "tmp dir"
  include_context "output dir"

  let(:command) do
    "mkdir abc && cd abc && echo stuff > abc.txt"
  end

  let(:config_body) do
    "c.command '#{command}', :path => 'abc'"
  end

  before do
    File.create "#{tmp_dir}/place.txt","fun"
  end

  let(:project) do
    res = Overapp::Project.new(:path => tmp_dir)
    res.stub(:config_body) { config_body }
    res
  end

  it 'runs' do
    project.write_to! output_dir
    Dir["#{output_dir}/**/*.*"].sort.should == ['abc.txt','place.txt'].sort.map { |x| "#{output_dir}/#{x}" }
  end
end
