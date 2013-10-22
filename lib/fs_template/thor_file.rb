module FsTemplate
  class ThorFile
    include FromHash
    attr_accessor :path, :full_body

    fattr(:split_note_and_body) do
      if full_body =~ /<thor>(.+)<\/thor>/m
        note = $1
        rest = full_body.gsub(/<thor>.+<\/thor>/m,"")
        {:note => note, :body => rest}
      else
        {:note => nil, :body => full_body}
      end
    end

    fattr(:body) { split_note_and_body[:body] }
    fattr(:note) { split_note_and_body[:note] }
  end
end