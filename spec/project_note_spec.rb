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

  it 'project no config' do
    lambda { FsTemplate::Project.new.config }.should raise_error
  end
end

describe "write project" do
  include_context "output dir"

  let(:repo_dir) do
    "#{input_dir}/repo"
  end
  let(:input_dir) do
    File.expand_path(File.dirname(__FILE__) + "/input")
  end
  let(:overlay_dir) do
    "#{input_dir}/top"
  end

  def files_equal(source_dir,target_dir,file)
    source = File.read("#{source_dir}/#{file}")
    target = File.read("#{target_dir}/#{file}")
    FileTest.should be_exist("#{target_dir}/#{file}")
    source.should == target
  end

  describe "from git" do
    before do
      FsTemplate.write_project overlay_dir, output_dir
    end

    it 'has README' do
      files_equal repo_dir, output_dir, "README.md"
    end

    it 'c.txt' do
      files_equal overlay_dir, output_dir, "c.txt"
    end

    it 'b.txt insert' do
      File.read("#{output_dir}/b.txt").should == %w(a 1 2 b c d).join("\n") + "\n"
    end
  end

  describe "from combined" do
    before do
      FsTemplate::Files.write_combined repo_dir,overlay_dir,output_dir
    end

    it 'has README' do
      files_equal repo_dir, output_dir, "README.md"
    end

  end
end