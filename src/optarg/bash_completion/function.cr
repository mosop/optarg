require "./text_formatter"

class Optarg::BashCompletion
  abstract class Function
    include TextFormatter

    macro inherited
      {%
        name = @type.name.split("::")[-1].underscore
      %}
      def name
        {{name}}
      end
    end

    getter g : Generator
    getter! header : String?
    getter body = %w()
    getter! footer : String?

    def initialize(@g, @header = nil, @footer = nil)
    end

    def <<(line : String)
      body << line
    end

    @text : String?
    def text
      @text ||= combine
    end

    def prefix
      g.prefix
    end

    def global
      g.first.prefix
    end

    def combine
      a = %w()
      a << "function #{prefix}#{name}() {"
      a << indent(header) if header?
      a << indent(body.join("\n"))
      a << indent(footer) if footer?
      a << "}"
      a.join("\n")
    end

    macro f(name)
      {% if name == :add %}
        "#{global}add"
      {% elsif name == :any %}
        "#{global}any"
      {% elsif name == :arg %}
        "#{prefix}arg"
      {% elsif name == :cur %}
        "#{global}cur"
      {% elsif name == :end %}
        "#{global}end"
      {% elsif name == :inc %}
        "#{global}inc"
      {% elsif name == :key %}
        "#{prefix}key"
      {% elsif name == :keyerr %}
        "#{global}keyerr"
      {% elsif name == :ls %}
        "#{prefix}ls"
      {% elsif name == :lskey %}
        "#{prefix}lskey"
      {% elsif name == :len %}
        "#{prefix}len"
      {% elsif name == :next %}
        "#{prefix}next"
      {% elsif name == :reply %}
        "#{global}reply"
      {% elsif name == :tag %}
        "#{prefix}tag"
      {% elsif name == :word %}
        "#{global}word"
      {% else %}
        {% raise "No function: #{name}" %}
      {% end %}
    end

    def key
      "#{global}k"
    end

    def len
      "#{global}l"
    end

    def found
      "#{global}f"
    end

    def word
      "#{global}w"
    end

    def index
      "#{global}i"
    end

    def arg_index
      "#{global}ai"
    end

    def cursor
      "#{global}c"
    end

    def keys
      "#{prefix}keys"
    end

    def tags
      "#{prefix}tags"
    end

    def occurs
      "#{prefix}occurs"
    end

    def lens
      "#{prefix}lens"
    end

    def args
      "#{prefix}args"
    end

    def words
      "#{prefix}words"
    end

    def nexts
      "#{prefix}nexts"
    end
  end
end
