describe 'binary' do
  it 'smoke' do
    path = File.dirname(__FILE__) + "/input/rails.png"
    body = Overapp.read(path)
    template_file = Overapp::TemplateFile.new(:path => path, :full_body => body)
    template_file.should_not be_has_note
  end

  describe 'manual' do
    include_context "projects"
    include_context "output dir"

    let(:mock_file_methods) { false }

    project "main" do |p|
      p.config :overlay,:widget
      p.file "README","hello"
      p.file "rails.png",Overapp.read(File.dirname(__FILE__) + "/input/rails.png")
    end

    project "widget" do |p|
      p.file "widget.rb","widget"
    end

    def fix_overlay_path
      path = project("main").path + "/.overlay"
      body = File.read(path)

      body = body.gsub("widget",project("widget").path)
      File.create path, body
      project("main").tap do |p|
        p.config_body!
        p.config!
      end
    end

    before do
      fix_overlay_path
    end

    has_file "README"
    has_file "rails.png"
    has_files 4

    it 'thing' do
      project('main').write_to! output_dir
      2.should == 2
    end
  end
end