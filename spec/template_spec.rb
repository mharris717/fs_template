require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe 'Template' do
  let(:template_file) do
    Overapp::TemplateFile.new(:full_body => full_body)
  end

  let(:base) do
    OpenStruct.new(:full_body => "abc")
  end

  let(:combined) do
    template_file.combined(base)
  end

  let(:full_body) do
    "<overapp>
    action: append
    template: erb
    </overapp>
#{body}"
  end

  describe "no vars" do
    let(:body) do
      "<%= 2+2 %>"
    end

    it 'works' do
      combined.full_body.should == "abc\n4"
    end
  end

  describe "no vars, no base" do
    let(:body) do
      "<%= 2+2 %>"
    end

    it 'works' do
      template_file.combined(nil).full_body.should == "\n4"
    end
  end

  describe "has var" do
    let(:body) do
      "<%= foo %>"
    end

    before do
      template_file.vars[:foo] = "bar"
    end

    it 'works' do
      combined.full_body.should == "abc\nbar"
    end
  end

  describe "not using template" do
    let(:full_body) do
      "<overapp>
      action: append
      </overapp>
#{body}"
    end
    let(:body) do
      "<%= 2+2 %>"
    end

    it 'works' do
      combined.full_body.should == "abc\n<%= 2+2 %>"
    end
  end

  describe "diff target file" do
    let(:full_body) do
      "<overapp>
      target: fun.txt
      </overapp>
#{body}"
    end
    let(:body) do
      "Hello"
    end

    it 'parsed_path' do
      combined.path.should == "fun.txt"
    end
  end

    describe "diff templated target file" do
      let(:full_body) do
        "<overapp>
        target: <%= target_filename %>
        </overapp>
  #{body}"
      end
      let(:body) do
        "Hello"
      end

      it 'parsed_path' do
        file = "#{rand(100000000)}.txt"
        template_file.vars[:target_filename] = file
        template_file.parsed_path.should == file
        combined.path.should == file
      end
    end
end