shared_context "output dir" do
  let(:output_dir) do
    Overapp::TmpDir.with
  end
  before do
    output_dir
  end
  after do
    ec "rm -rf #{output_dir}", :silent => true
  end
end