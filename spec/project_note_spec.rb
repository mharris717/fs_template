require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

shared_context "p1" do
  let(:config) do
    res = Overapp::ProjectConfig.new
    res.body = config_body
    res.load!
    res
  end

  let(:project) do
    res = Overapp::Project.new(:path => "/fun")
    res.stub(:config_body) { config_body }
    res
  end

  before do
    Overapp::Files.stub(:load) { Overapp::Files.new }
  end
end

describe "ProjectConfig" do
  include_context "p1"

  describe "one base" do
    let(:config_body) do
      "c.base :foo"
    end

    it 'eval' do
      config.overapps.first.descriptor.should == :foo
    end
  end

  describe "base and overapp" do
    let(:config_body) do
      "c.base :foo
      c.overapp :bar"
    end

    it 'eval' do
      config.overapps.map { |x| x.descriptor }.should == [:foo,:bar]
    end
  end

  it 'project no config' do
    lambda { Overapp::Project.new.config }.should raise_error
  end
end

describe 'Project' do
  include_context "p1"
  let(:config_body) do
    "c.base :foo
    c.overapp :bar"
  end

  it 'overapps' do
    project.overapps.size.should == 3
    project.overapp_entries.last.descriptor.should == "/fun"
  end
end

describe 'Project2' do
  include_context "projects"
  project do |p|
    p.config "c.base :foo; c.overapp :bar"
  end

  it 'overapps' do
    project.overapps.size.should == 3
    project.overapp_entries.last.descriptor.should == project.path
  end
end

describe 'Project with command' do
  include_context "projects"
  project do |p|
    p.config "c.base :foo; c.overapp :bar; c.command 'ls'"
  end

  it 'commands' do
    project.overapps.size.should == 4
  end
end

describe 'Project order' do
  include_context "p1"
  let(:config_body) do
    "c.base :foo
    c.overapp :bar
    c.command 'ls'"
  end

  if false
    it 'write' do
      output_path = "/tmp/f/t/r/r"

      Overapp.should_receive(:ec).with("cd #{output_path} && ls", :silent => true)
      Overapp::Project::Write.class_eval do
        def git_commit(*args)
        end
      end
      project.combined_files("/tmp/sdfdsdfsd").stub("write_to!")

      project.write_to! output_path
    end
  end
end

describe 'Project order' do
  include_context "p1"
  let(:config_body) do
    "c.base :foo
    c.overapp '.'
    c.overapp :bar"
  end

  it "doesn't have self twice" do
    project.overapp_entries.size.should == 3
    project.overapp_entries[1].descriptor.should == "/fun"
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
  let(:overapp_dir) do
    "#{input_dir}/top"
  end

  def files_equal(source_dir,target_dir,file)
    source = File.read("#{source_dir}/#{file}")
    target = File.read("#{target_dir}/#{file}")
    FileTest.should be_exist("#{target_dir}/#{file}")
    source.should == target
  end

  describe "from git" do
    before(:all) do
      Overapp.write_project overapp_dir, output_dir
    end

    it 'has README' do
      files_equal repo_dir, output_dir, "README.md"
    end

    it 'c.txt' do
      files_equal overapp_dir, output_dir, "c.txt"
    end

    it 'b.txt insert' do
      File.read("#{output_dir}/b.txt").should == %w(a 1 2 b c d).join("\n") + "\n"
    end
  end
end