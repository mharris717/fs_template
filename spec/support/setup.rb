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

  let(:base) do
    res = FsTemplate::Files.new
    self.class.files.select { |x| x[:loc] == :base }.each do |f|
      res.add f
    end
    res
  end

  let(:on_top) do
    res = FsTemplate::Files.new
    self.class.files.select { |x| x[:loc] == :on_top }.each do |f|
      res.add f
    end
    res
  end

  let(:combined) do
    base.apply(on_top)
  end
end