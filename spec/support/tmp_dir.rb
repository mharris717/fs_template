shared_context "tmp dir" do
  let(:tmp_dir) do
    Overapp::TmpDir.with
  end
  before do
    tmp_dir
  end
  after do
    ec "rm -rf #{tmp_dir}", :silent => true
  end
end