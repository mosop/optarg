class Optarg::Completion
  module TextFormatter
    def indent(s, spaces = "  ", first = true)
      a = %w()
      s.split("\n").each_with_index do |e, i|
        if i == 0 && !first
          a << "#{e}"
        else
          a << "#{spaces}#{e}"
        end
      end
      a.join("\n")
    end

    def string(s : String?)
      s ||= ""
      "'" + s.gsub(/(\\|')/, "'\\\\\\1'") + "'"
    end

    def strings_in_string(a : Array(String)?)
      a ||= %w()
      string(a.map{|i| string(i)}.join(" "))
    end

    def matching_words(a : Array(String)?)
      a ||= %w()
      s = a.join(" ")
      string(s.empty? ? s : " #{s} ")
    end
  end
end
