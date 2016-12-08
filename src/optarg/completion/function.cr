require "./text_formatter"

class Optarg::Completion
  abstract class Function
    include TextFormatter

    macro inherited
      def name
        "#{prefix}{{@type.name.split("::")[-1].underscore.id}}"
      end
    end

    getter g : CompletionGenerators::Base
    getter header = %w()
    getter body = %w()
    getter footer = %w()

    def initialize(@g)
      if zsh?
        header << <<-EOS
        setopt localoptions ksharrays
        EOS
      end
      make
    end

    def zsh?
      g.zsh?
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
      sections = %w()
      sections << header.join("\n\n") unless header.empty?
      sections << body.join("\n") unless body.empty?
      sections << footer.join("\n\n") unless footer.empty?
      a = %w()
      a << "function #{name}() {"
      a << indent(sections.join("\n\n"))
      a << "}"
      a.join("\n")
    end

    macro f(name)
      {% if name == :act %}
        "#{global}act"
      {% elsif name == :add %}
        "#{global}add"
      {% elsif name == :any %}
        "#{global}any"
      {% elsif name == :arg %}
        "#{prefix}arg"
      {% elsif name == :cur %}
        "#{global}cur"
      {% elsif name == :end %}
        "#{global}end"
      {% elsif name == :found %}
        "#{global}found"
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

    def cmds
      "#{prefix}cmds"
    end

    def acts
      "#{prefix}acts"
    end

    def nexts
      "#{prefix}nexts"
    end
  end
end
