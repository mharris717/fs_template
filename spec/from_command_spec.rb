require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe 'FromCommand' do
  let(:command) do
    "mkdir abc && cd abc && echo stuff > abc.txt"
  end

  let(:from_command) do
    FsTemplate::FromCommand.new(:command => command, :path => "abc")
  end

  it 'files' do
    from_command.files.size.should == 1
    from_command.files.first.path.should == 'abc.txt'
    from_command.files.first.full_body.strip.should == 'stuff'
  end
end