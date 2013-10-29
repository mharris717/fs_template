shared_context "output dir" do
  def make_fresh_output_dir
    `mkdir /tmp/fresh_output` unless FileTest.exist?("/tmp/fresh_output")
    dir = "/tmp/fresh_output/#{rand(10000000000000)}"
    `mkdir #{dir}`
    dir
  end

  let(:output_dir) { make_fresh_output_dir }

  after do
    `rm -rf #{output_dir}`
  end
end