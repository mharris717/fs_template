module Overapp
  class TemplateFile
    class Params
      include FromHash
      attr_accessor :full_body
      def body; full_body; end
      include Enumerable
      def each(&b)
        note_params.each(&b)
      end

      def split_note_and_body
        res = []
        remaining_body = full_body
        while remaining_body
          if remaining_body =~ /^<over(?:lay|app)>(.+)<\/over(?:lay|app)>(.*)(<over(?:lay|app)>.+)/m
            note = $1
            rest = $2
            remaining_body = $3
            res << {:note => note, :body => rest}
          elsif remaining_body =~ /^<over(?:lay|app)>(.+)<\/over(?:lay|app)>(.*)/m
            note = $1
            rest = $2
            remaining_body = nil
            res << {:note => note, :body => rest}
          else
            res << {:note => nil, :body => remaining_body}
            remaining_body = nil
          end
        end
        res
      rescue => exp
        puts "Error in split_note_and_body #{path}"
        raise exp
      end


      def note_params_single(one)
        res = {}
        note = one[:note]
        res[:body] = one[:body]

        if note
          lines = note.split("\n").select { |x| x.present? }
          if (lines.size == 1) && !(lines.first =~ /[a-z]+:/)
            res[:action] = lines.first.strip
          else
            lines.each do |line|
              parts = line.split(":").select { |x| x.present? }
              if parts.size > 2
                parts = [parts[0],parts[1..-1].join(":")]
              end
              parts = parts.map { |x| x.strip }
              raise "bad #{path} #{parts.inspect}" unless parts.size == 2
              res[parts[0].to_sym] = parts[1]
            end
          end
        end
        res
      end

      fattr(:split_parts) { split_note_and_body }

      fattr(:note_params) do
        split_parts.map do |one|
          note_params_single(one)
        end
      end

      def has_note?
        note_params.any? { |x| x[:action].present? }
      end
    end
  end
end