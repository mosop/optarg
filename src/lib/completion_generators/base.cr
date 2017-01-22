class Optarg::CompletionGenerators
  abstract class Base
    include Completion::TextFormatter

    getter! previous : Base?
    @completion : Completion
    getter base_prefix : String
    @keymap = {} of String => Int32

    @function_data = [] of Completion::Function
    @key_data = {} of Int32 => Array(String)
    @arg_data = {} of Int32 => Int32
    @act_data = {} of Int32 => String?
    @cmd_data = {} of Int32 => String?
    @len_data = {} of Int32 => Int32
    @next_data = {} of Int32 => Array(String)
    @occur_data = {} of Int32 => Int32
    @tag_data = {} of Int32 => Array(String)
    @word_data = {} of Int32 => Array(String)?

    @header = %w()
    @constants = %w()
    @functions = %w()
    @next_libs = %w()
    @sections = %w()
    @result : String?

    def initialize(previous : Base, completion : Completion)
      @previous = previous
      initialize completion, previous.entry_point
    end

    def initialize(@completion : Completion, @base_prefix : String)
    end

    def zsh?
      @completion.type == :zsh
    end

    def next_completion_for(model)
      case @completion.type
      when :zsh
        model.zsh_completion
      else
        model.bash_completion
      end
    end

    @entry_point : String?
    def entry_point
      @entry_point ||= first? ? @base_prefix : "#{@base_prefix}__#{model.name}"
    end

    @prefix : String?
    def prefix
      @prefix ||= "#{entry_point}___"
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

    def result
      @result ||= make
    end

    def make
      add_header
      add_functions
      add_each_definition
      add_each_arg
      make_constants
      make_functions
      add_section @header, "\n\n"
      add_section @constants, "\n"
      add_section @functions, "\n\n"
      add_section @next_libs, "\n\n"
      @sections.join("\n\n")
    end

    def add_section(a, separator = "\n")
      @sections << a.join(separator) unless a.empty?
    end

    def add_header
    end

    def add_each_definition
      model.definitions.all.each do |kv|
        make_definition kv[1]
      end
    end

    def make_definition(df)
      @keymap[df.key] = @keymap.size
      add_key df
      add_act df
      add_cmd df
      add_len df
      add_next df
      add_occur df
      add_word df
      add_tag df
    end

    def add_key(df)
      @key_data[@keymap[df.key]] = df.names
    end

    def add_len(df)
      @len_data[@keymap[df.key]] = df.completion_length(self)
    end

    def add_occur(df)
      @occur_data[@keymap[df.key]] = df.completion_max_occurs(self)
    end

    def add_word(df)
      @word_data[@keymap[df.key]] = df.completion_words(self)
    end

    def add_cmd(df)
      @cmd_data[@keymap[df.key]] = df.completion_command(self)
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

    def add_act(df)
      @act_data[@keymap[df.key]] = if sym = df.completion_action(self)
        sym.to_s
      end
    end

    def add_next(df)
      if data = df.completion_next_models_by_value(self)
        if data.size > 0
          @next_data[@keymap[df.key]] = data.keys
          @function_data << Completion::Functions::Next.new(self, data)
          data.each do |k, v|
            @next_libs << next_completion_for(v).new_generator(self).result
          end
        end
      end
    end

    def add_tag(df)
      key = @keymap[df.key]
      @tag_data[key] = %w()
      @tag_data[key] << "term" if df.is_a?(Definitions::Terminator)
      @tag_data[key] << "opt" if df.is_a?(DefinitionMixins::Option)
      @tag_data[key] << "arg" if df.is_a?(DefinitionMixins::Argument)
      @tag_data[key] << "varg" if df.is_a?(Definitions::StringArrayArgument)
      @tag_data[key] << "stop" if df.stops?
    end

    def add_each_arg
      model.definitions.arguments.each_with_index do |kv, i|
        add_arg i, kv[1]
      end
    end

    def add_arg(i, df)
      @arg_data[i] = @keymap[df.key]
    end

    def make_constants
      make_constant :keys, @key_data {|v| matching_words(v)}
      make_constant :args, @arg_data {|v| v.to_s}
      make_constant :acts, @act_data {|v| string(v)}
      make_constant :cmds, @cmd_data {|v| string(v)}
      make_constant :lens, @len_data {|v| v.to_s}
      make_constant :nexts, @next_data {|v| matching_words(v)}
      make_constant :occurs, @occur_data {|v| v.to_s}
      make_constant :tags, @tag_data {|v| matching_words(v)}
      make_constant :words, @word_data {|v| matching_words(v)}
    end

    def make_constant(name, data)
      a = %w()
      (0..(@keymap.size-1)).each do |key|
        a << yield data[key]?
      end
      @constants << "#{prefix}#{name}=(" + a.join(" ") + ")"
    end

    def make_functions
      @function_data.each do |f|
        @functions << f.text
      end
    end

    def add_functions
      if first?
        @function_data << Completion::Functions::Act.new(self)
        @function_data << Completion::Functions::Add.new(self)
        @function_data << Completion::Functions::Any.new(self)
        @function_data << Completion::Functions::Cur.new(self)
        @function_data << Completion::Functions::End.new(self)
        @function_data << Completion::Functions::Found.new(self)
        @function_data << Completion::Functions::Inc.new(self)
        @function_data << Completion::Functions::Keyerr.new(self)
        @function_data << Completion::Functions::Word.new(self)
      end
      @function_data << Completion::Functions::Main.new(self)
      @function_data << Completion::Functions::Arg.new(self)
      @function_data << Completion::Functions::Key.new(self)
      @function_data << Completion::Functions::Len.new(self)
      @function_data << Completion::Functions::Ls.new(self)
      @function_data << Completion::Functions::Lskey.new(self)
      @function_data << Completion::Functions::Tag.new(self)
    end
  end
end
