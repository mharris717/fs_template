require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe 'Template' do
  let(:template_file) do
    Overapp::TemplateFile.new(:full_body => body)
  end

  let(:body) do
    "<overapp>
    action: append
    template: erb
    </overapp>
<%= 2+2 %>"
  end

  let(:base) do
    OpenStruct.new(:full_body => "abc")
  end

  let(:combined) do
    template_file.combined(base)
  end

  it 'works' do
    combined.full_body.should == "abc\n4"
  end
end