class Object
  def dsl_method(name)
    attr_writer name
    define_method(name) do |*args|
      if args.size == 0
        instance_variable_get("@#{name}")
      elsif args.size == 1
        send("#{name}=",args.first)
      else
        raise "Bad"
      end
    end
  end
end

module MockRawDirLoader
  class FactoryOld
    include FromHash
    attr_accessor :files
    def new(*args)
      Instance.new(:files => files)
    end
  end

  class Factory
    include FromHash
    attr_accessor :projects
    def new(ops)
      desc = ops[:descriptor]
      raise "no desc" unless desc.present?
      files = 42
      Instance.new(:files => files)
    end
  end
  class Instance < Overapp::Load::Base
    include FromHash
    attr_accessor :files
    def load(*args)
      res = Overapp::Files.new
      files.each do |f|
        res.add :file => f.path, :body => f.body
      end
      res
    end
    def commit_message
      "Pending"
    end
  end
end

class ProjectDSL
  dsl_method :config
  dsl_method :path
  attr_accessor :name
  include FromHash

  fattr(:project) do
    res = Overapp::Project.new
    res.config_body = config || ""
    res.path = path || "/tmp/#{rand(100000000000000000)}"
    #res.load_raw_dir_class = MockRawDirLoader::Factory.new(:files => files)
    res
  end

  def file(path,body)
    self.files << OpenStruct.new(:path => path, :body => body)
  end
  fattr(:files) { [] }
end

shared_context "projects" do
  class << self
    def project(name="default",&b)
      dsl = ProjectDSL.new(:name => name)
      b[dsl]
      raise "project #{name} already exists" if project_dsls[name]
      self.project_dsls[name] = dsl
    end
    def project_dsls
      @project_dsls ||= {}
    end
  end

  let(:project) do
    self.class.project_dsls.values.first.project
  end

  let(:combined) do
    project.combined_files
  end

  before do
    Overapp.stub(:dir_files_full) do |dir|
      dsl = self.class.project_dsls.values.find { |x| x.project.path == dir || x.name.to_s == dir.to_s }
      if dsl
        dsl.files.map do |f|
          {:file => f.path, :body => f.body}
        end
      else
        raise "no dir #{dir}, possible: \n" + self.class.project_dsls.values.map { |x| x.project.path }.join("\n")
      end
    end

  end
end

describe "project context" do
  include_context "projects"

  project do |p|
    p.config "c.base :foo
              c.overapp :bar"
    p.path "/fun"
  end

  it 'smoke' do
    project.should be
  end

  it 'overapps' do
    project.overapps.size.should == 3
  end
end

describe "basic file loading" do
  include_context "projects"
  include_context "output dir"

  project do |p|
    p.file "abc.txt","hello"
  end

  it 'file count' do
    combined.size.should == 1
    combined.first.tap do |f|
      f.path.should == "abc.txt"
      f.body.should == 'hello'
    end
  end
end

describe "multiple projects" do
  include_context "projects"
  include_context "output dir"

  project "main" do |p|
    p.config "c.overlay 'widget'"
    p.file "README","hello"
  end

  project "widget" do |p|
    p.file "widget.rb","class Widget; end"
  end

  it 'file count' do
    combined.size.should == 2
  end
end




