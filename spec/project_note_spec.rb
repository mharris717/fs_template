require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe "ProjectConfig" do
  let(:config) do
    res = Overapp::ProjectConfig.new
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

  describe "base and overapp" do
    let(:config_body) do
      "c.base :foo
      c.overapp :bar"
    end

    it 'eval' do
      config.load!
      config.base.should == :foo
      config.overapps.should == [:bar]
    end
  end

  it 'project no config' do
    lambda { Overapp::Project.new.config }.should raise_error
  end
end

describe 'Project' do
  let(:config_body) do
    "c.base :foo
    c.overapp :bar"
  end

  let(:project) do
    res = Overapp::Project.new(:path => "/fun")
    res.stub(:config_body) { config_body }
    res
  end

  before do
    Overapp::Files.stub(:load) { Overapp::Files.new }
  end

  it 'overapps' do
    project.overapps.size.should == 2
    project.overapp_paths.last.should == "/fun"
  end
end

describe 'Project with command' do
  let(:config_body) do
    "c.base :foo
    c.overapp :bar
    c.command 'ls'"
  end

  let(:project) do
    res = Overapp::Project.new(:path => "/fun")
    res.stub(:config_body) { config_body }
    res
  end

  before do
    Overapp::Files.stub(:load) { Overapp::Files.new }
  end

  it 'commands' do
    project.commands(:after).should == ["ls"]
  end
end

describe 'Project order' do
  let(:config_body) do
    "c.base :foo
    c.overapp :bar
    c.command 'ls'"
  end

  let(:project) do
    res = Overapp::Project.new(:path => "/tmp/a/b/c/fun")
    res.stub(:config_body) { config_body }
    res
  end

  before do
    Overapp::Files.stub(:load) { Overapp::Files.new }
  end

  it 'write' do
    output_path = "/tmp/f/t/r/r"

    Overapp.should_receive(:ec).with("cd #{output_path} && ls", :silent => true)
    project.stub(:git_commit)
    project.combined_files.stub("write_to!")

    project.write_to! output_path
  end
end

describe 'Project with no base' do
  let(:config_body) do
    "c.base 'mkdir foo && echo stuff > foo/abc.txt', :type => :command, :path => :foo"
  end

  let(:output_path) do
    res = "/tmp/#{rand(1000000000000000)}"
    `mkdir #{res}`
    res
  end

  after do
    `rm -rf #{output_path}`
  end

  let(:project) do
    res = Overapp::Project.new(:path => "/tmp/a/b/c/fun")
    res.stub(:config_body) { config_body }
    res
  end

  it 'write' do
    #Overapp.should_receive(:ec).with("echo stuff > abc.txt", :silent => true)
    project.stub(:git_commit)
    project.stub(:overapp_paths) { [] }

    project.write_to! output_path

    File.read("#{output_path}/abc.txt").strip.should == 'stuff'
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
    before do
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

  if false
    describe "from combined" do
      before do
        Overapp::Files.write_combined repo_dir,overapp_dir,output_dir
      end

      it 'has README' do
        files_equal repo_dir, output_dir, "README.md"
      end

      it 'has .abc' do
        files_equal repo_dir, output_dir, ".abc"
      end
    end
  end
end