require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe 'Git' do
  it 'smoke' do
    Overapp::TmpDir.with do |dir|
      Overapp::Git.commit(dir,"stuff") do
        File.create "#{dir}/abc.txt","hello"
      end
    end
    2.should == 2
  end
end
