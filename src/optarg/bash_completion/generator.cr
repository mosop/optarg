class Optarg::BashCompletion
  class Generator
    include TextFormatter

    getter! previous : Generator?
    @completion : BashCompletion
    getter base_prefix : String
    @keymap = {} of String => Int32

    @keys : Array(String)
    @occurs : Array(String)
    @words : Array(String)
    @cmds : Array(String)
    @acts : Array(String)
    @nexts : Array(String)
    @lens : Array(String)
    @tag_data = {} of Int32 => Array(String)
    @tags : Array(String)
    @args : Array(String)
    @variables = %w()
    @function_data = [] of Function
    @functions = %w()
    @next_libs = %w()
    @sections = %w()
    @result : String?

    def initialize(previous : Generator, completion : BashCompletion)
      @previous = previous
      initialize completion, previous.prefix
    end

    def initialize(@completion : BashCompletion, base_prefix : String)
      @base_prefix = base_prefix.sub(/_+$/, "") + "__"
      @keys = ["declare -a #{prefix}keys"]
      @occurs = ["declare -ia #{prefix}occurs"]
      @words = ["declare -a #{prefix}words"]
      @cmds = ["declare -a #{prefix}cmds"]
      @acts = ["declare -a #{prefix}acts"]
      @nexts = ["declare -a #{prefix}nexts"]
      @lens = ["declare -a #{prefix}lens"]
      @tags = ["declare -a #{prefix}tags"]
      @args = ["declare -ia #{prefix}args"]
    end

    def entry_point
      "#{@prefix}reply"
    end

    def model
      @completion.model
    end

    def first?
      previous?.nil?
    end

    def first
      first? ? self : previous.first
    end

    @prefix : String?
    def prefix
      @prefix ||= first? ? @base_prefix : "#{@base_prefix}#{model.name}__"
    end

    def result
      @result ||= make
    end

    def make
      make_base
      make_each_definition
      make_each_arg
      make_tags
      make_functions
      combine
    end

    def combine
      combine_section @variables
      combine_section @keys
      combine_section @lens
      combine_section @occurs
      combine_section @words
      combine_section @cmds
      combine_section @acts
      combine_section @nexts
      combine_section @args
      combine_section @tags
      combine_section @functions, "\n\n"
      combine_section @next_libs, "\n\n"
      @sections.join("\n\n")
    end

    def combine_section(a, separator = "\n")
      @sections << a.join(separator) unless a.empty?
    end

    def make_each_definition
      model.definitions.all.each do |kv|
        make_definition kv[1]
      end
    end

    def make_definition(df)
      make_keys df
      make_lens df
      make_occurs df
      make_words df
      make_cmds df
      make_acts df
      make_nexts df
      make_tag_data df
    end

    def make_keys(df)
      @keymap[df.key] = @keymap.size
      @keys << "#{prefix}keys[#{@keymap[df.key]}]=#{matching_words(df.names)}"
    end

    def make_lens(df)
      @lens << "#{prefix}lens[#{@keymap[df.key]}]=#{df.completion_length(self)}"
    end

    def make_occurs(df)
      @occurs << "#{prefix}occurs[#{@keymap[df.key]}]=#{df.completion_max_occurs(self) || -1}"
    end

    def make_words(df)
      @words << "#{prefix}words[#{@keymap[df.key]}]=#{matching_words(df.completion_words(self))}"
    end

    def make_cmds(df)
      @cmds << "#{prefix}cmds[#{@keymap[df.key]}]=#{string(df.completion_command(self))}"
    end

    ACTIONS = %i(
      alias
      arrayvar
      binding
      builtin
      command
      directory
      disabled
      enabled
      export
      file
      function
      group
      helptopic
      hostname
      job
      keyword
      running
      service
      setopt
      shopt
      signal
      stopped
      user
      variable
    )

    def make_acts(df)
      act = if sym = df.completion_type(self)
        if ACTIONS.includes?(sym)
          sym.to_s
        end
      end
      @acts << "#{prefix}acts[#{@keymap[df.key]}]=#{string(act)}"
    end

    def make_nexts(df)
      if data = df.completion_next_models_by_value(self)
        if data.size > 0
          @nexts << "#{prefix}nexts[#{@keymap[df.key]}]=#{matching_words(data.keys)}"
          @function_data << Functions::Next.new(self, data)
          data.each do |k, v|
            @next_libs << v.bash_completion.new_generator(self).result
          end
        end
      end
    end

    def make_tag_data(df)
      key = @keymap[df.key]
      @tag_data[key] = %w()
      @tag_data[key] << "term" if df.is_a?(Definitions::Terminator)
      @tag_data[key] << "opt" if df.is_a?(DefinitionMixins::Option)
      @tag_data[key] << "arg" if df.is_a?(DefinitionMixins::Argument)
      @tag_data[key] << "varg" if df.is_a?(Definitions::StringArrayArgument)
      @tag_data[key] << "stop" if df.stops?
    end

    def make_each_arg
      model.definitions.arguments.each_with_index do |kv, i|
        make_arg i, kv[1]
      end
    end

    def make_arg(i, df)
      @args << "#{prefix}args[#{i}]=#{@keymap[df.key]}"
    end

    def make_tags
      @tag_data.each do |k, v|
        @tags << "#{prefix}tags[#{k}]=#{matching_words(v)}"
      end
    end

    def make_functions
      @function_data.each do |f|
        @functions << f.text
      end
    end

    def make_base
      if first?
        @function_data << Functions::Add.new(self)
        @function_data << Functions::Any.new(self)
        @function_data << Functions::Cur.new(self)
        @function_data << Functions::End.new(self)
        @function_data << Functions::Inc.new(self)
        @function_data << Functions::Keyerr.new(self)
        @function_data << Functions::Word.new(self)
      end
      @function_data << Functions::Arg.new(self)
      @function_data << Functions::Key.new(self)
      @function_data << Functions::Len.new(self)
      @function_data << Functions::Ls.new(self)
      @function_data << Functions::Lskey.new(self)
      @function_data << Functions::Reply.new(self)
      @function_data << Functions::Tag.new(self)
    end
  end
end
