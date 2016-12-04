class Optarg::BashCompletion
  module TextFormatter
    def indent(s, spaces = "  ")
      s.split("\n").map{|i| "#{spaces}#{i}"}.join("\n")
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
