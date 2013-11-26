require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe 'FromCommand' do
  include_context "tmp dir"
  include_context "output dir"

  let(:project) do
    res = Overapp::Project.new(:path => tmp_dir)
    res.stub(:config_body) { config_body }
    res
  end

  before do
    File.create "#{tmp_dir}/place.txt","fun"
    project.write_to! output_dir
  end

  def files_should_equal(files)
    Dir["#{output_dir}/**/*.*"].sort.should == files.sort.map { |x| "#{output_dir}/#{x}" }
  end

  describe "with subdir" do
    let(:command) do
      "mkdir abc && cd abc && echo stuff > abc.txt"
    end

    let(:config_body) do
      "c.command '#{command}', :path => 'abc'"
    end

    it 'has files' do
      files_should_equal ['abc.txt','place.txt']
    end
  end

  describe "at root" do
    let(:command) do
      "echo stuff > abc.txt"
    end

    let(:config_body) do
      "c.command '#{command}'"
    end

    it 'has files' do
      files_should_equal ['abc.txt','place.txt']
    end
  end
end
