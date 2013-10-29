require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe "ProjectConfig" do
  let(:config) do
    res = FsTemplate::ProjectConfig.new
    res.body = config_body
    res
  end

  describe "one base" do
    let(:config_body) do
      "c.base :foo"
    end

    it 'smoke' do
      config.should be
    end

    it 'eval' do
      config.load!
      config.base.should == :foo
    end
  end

  describe "base and overlay" do
    let(:config_body) do
      "c.base :foo
      c.overlay :bar"
    end

    it 'eval' do
      config.load!
      config.base.should == :foo
      config.overlays.should == [:bar]
    end
  end

  it 'project no config' do
    lambda { FsTemplate::Project.new.config }.should raise_error
  end
end

describe 'Project' do
  let(:config_body) do
    "c.base :foo
    c.overlay :bar"
  end

  let(:project) do
    res = FsTemplate::Project.new(:path => "/fun")
    res.stub(:config_body) { config_body }
    res
  end

  before do
    FsTemplate::Files.stub(:load) { FsTemplate::Files.new }
  end

  it 'overlays' do
    project.overlays.size.should == 2
    project.overlay_paths.last.should == "/fun"
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

    it 'has .abc' do
      files_equal repo_dir, output_dir, ".abc"
    end

  end
end