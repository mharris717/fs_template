shared_context "setup" do
  class << self
    fattr(:files) { [] }
    def base_file(file,body)
      self.files << {:loc => :base, :file => file, :body => body}
    end
    def on_top_file(file,body)
      self.files << {:loc => :on_top, :file => file, :body => body}
    end
  end

  let(:file_class) { Overapp::TemplateFile }

  let(:base) do
    res = Overapp::Files.new(:file_class => file_class)
    self.class.files.select { |x| x[:loc] == :base }.each do |f|
      res.add f
    end
    res
  end

  let(:on_top) do
    res = Overapp::Files.new(:file_class => file_class)
    self.class.files.select { |x| x[:loc] == :on_top }.each do |f|
      res.add f
    end
    res
  end

  let(:combined) do
    base.apply(on_top)
  end
end