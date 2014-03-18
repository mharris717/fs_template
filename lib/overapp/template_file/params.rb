module Overapp
  class TemplateFile
    class Params
      include FromHash
      attr_accessor :full_body, :path, :var_obj
      def body; full_body; end
      include Enumerable
      def each(&b)
        note_params.each(&b)
      end

      def split_regexes
        res = []
        res << /^<over(?:lay|app)>(.+?)<\/over(?:lay|app)>(.*)(<over(?:lay|app)>.+)$/m
        res << /^<over(?:lay|app)>(.+)<\/over(?:lay|app)>(.*)/m
        res
      end

      def regex_match_hash(remaining_body)
        split_regexes.each do |split_regex|
          if remaining_body =~ split_regex
            return {:note => $1, :body => $2, :remaining_body => $3}
          end
        end
        nil
      end

      def split_note_and_body
        res = []
        remaining_body = full_body
        while remaining_body
          next_hash = regex_match_hash(remaining_body)
          if next_hash
            remaining_body = next_hash.delete(:remaining_body)
            res << next_hash
          else
            res << {:note => nil, :body => remaining_body}
            remaining_body = nil
          end
        end
        res
      rescue => exp
        raise "split_note_and_body #{path} #{exp.message}"
      end

      def note_params_single(one)
        #puts "single start " + one.inspect

        res = {:body => one[:body]}

        if one[:note]
          one[:note] = var_obj.render(one[:note])
          lines = one[:note].split("\n").select { |x| x.present? }
          if lines.size == 1 && !(lines.first =~ /[a-z]+:/)
            res[:action] = lines.first.strip
          else
            res = res.merge(note_params_single_hash(lines))
          end
        end

        #puts "single end #{res.inspect}"

        res
      end

      def note_params_single_hash(lines)
        lines.inject({}) do |res,line|
          parts = Overapp.split_first(line,":").map { |x| x.strip }
          res.merge(parts[0].to_sym => parts[1])
        end
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

      def target_path
        res = note_params.find { |x| x[:target] || x['target'] }
        if res
          res[:target] || res['target']
        else
          nil
        end
      end
    end
  end
end