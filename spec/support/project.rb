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

class ProjectDSL
  dsl_method :path

  attr_accessor :name
  include FromHash

  def config_hash(method,arg,ops={})
    res = "c.#{method} '#{arg}'"
    ops.each do |k,v|
      res << ", :#{k} => '#{v}'"
    end
    config res
  end
  def config(*args)
    if args.length >= 2
      config_hash(*args)
    elsif args.first.kind_of?(Hash)
      raise "first hash arg"
    elsif args.size == 1
      self.configs << args.first
    else
      raise "bad"
    end
  end
  def config_body
    configs.join("\n")
  end
  fattr(:configs) { [] }

  fattr(:project) do
    res = Overapp::Project.new
    res.config_body = config_body
    res.path = path || "/tmp/#{rand(100000000000000000)}"

    res.vars = res.vars.merge(vars)
    res
  end

  def file(path,body,overlay_ops={})
    if overlay_ops.size > 0
      inner = []
      overlay_ops.each do |k,v|
        inner << "#{k}: #{v}"
      end
      str = "<overlay>\n" + inner.join("\n") + "\n</overlay>"
      body = str + body
    end

    self.files << OpenStruct.new(:path => path, :body => body)
  end

  def var(k,v)
    vars[k] = v
  end

  fattr(:files) { [] }
  fattr(:vars) { {} }
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
    fattr(:vars) { {} }
    def var(k,v)
      vars[k] = v
    end

    def has_files(num)
      it "has #{num} files" do
        combined.size.should == num
      end
    end

    def has_file(name,*args)
      it "file #{name} has proper body" do
        file = combined.find { |x| x.path == name }
        file.should be
        if args.size > 0
          file.body.should == args.first
        end
      end
    end
  end

  def project(name=nil)
    if name
      self.class.project_dsls[name].project
    else
      self.class.project_dsls.values.first.project
    end
  end

  let(:combined) do
    project.combined_files
  end

  def find_dsl(dir)
    dsl = self.class.project_dsls.values.find { |x| x.project.path == dir || x.name.to_s == dir.to_s }
    raise "no dir #{dir}, possible: \n" + self.class.project_dsls.values.map { |x| x.project.path }.join("\n") unless dsl
    dsl
  end

  before do
    Overapp.stub(:dir_files_full) do |dir|
      find_dsl(dir).files.map do |f|
        {:file => f.path, :body => f.body}
      end
    end

    Overapp::Project.stub("project?") do |dir|
      find_dsl(dir).config_body.present?
    end

    Overapp::Project.stub("load") do |ops|
      dir = ops[:path]
      find_dsl(dir).project
    end

    self.class.vars.each do |k,v|
      Overapp::Var.set k,v
    end

  end

  after do
    Overapp::Var.clear!
  end
end