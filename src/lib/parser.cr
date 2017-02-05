module Optarg
  abstract class Parser
    ::Callback.enable
    define_callback_group :validate, Proc(Model, Nil)

    # :nodoc:
    alias Node = NamedTuple(args: Array(String), definitions: Array(Definitions::Base))

    # Returns a target model instance.
    getter data : Model

    # :nodoc:
    getter parsed_nodes = [] of Node

    # :nodoc:
    getter nameless_args = %w()

    # :nodoc:
    getter parsed_args = %w()

    # :nodoc:
    getter unparsed_args = %w()

    @argument_index = 0
    # :nodoc:
    getter index = 0

    # :nodoc:
    def initialize(data)
      @data = data
      @args = ValueContainer.new(self)
    end

    @args : ValueContainer?
    # :nodoc:
    def args
      @args.not_nil!
    end

    # :nodoc:
    def input_args
      data.__argv
    end

    # :nodoc:
    def self.new_node(args = %w(), *definitions)
      node = {args: args, definitions: [] of Definitions::Base}
      definitions.each do |df|
        node[:definitions] << df
      end
      node
    end

    @definitions : DefinitionSet?
    # :nodoc:
    def definitions
      @definitions ||= data.__klass.definitions
    end

    # :nodoc:
    def stopped?
      return false if parsed_nodes.size == 0
      return parsed_nodes.last[:definitions].any?{|i| i.stops? || i.terminates? || i.unknown?}
    end

    on_validate do |o|
      o.definitions.values.each do |kv|
        kv[1].validate(o)
      end
    end

    # :nodoc:
    def parse
      definitions.all.each do |kv|
        kv[1].initialize_before_parse(self)
      end
      resume
      definitions.all.each do |kv|
        kv[1].initialize_after_parse(self)
      end
      run_callbacks_for_validate(data) do
      end
    end

    # :nodoc:
    def eol?
      @index == input_args.size
    end

    # :nodoc:
    def resume
      until eol? || stopped?
        visit
      end
    ensure
      @unparsed_args = self[0..-1] if left > 0
      @index = input_args.size
    end

    # :nodoc:
    def visit
      arg = self[0]
      if visit_terminator
        return
      end
      if arg =~ /^-\w\w/
        visit_concatenated_options
        return
      end
      if arg =~ /^-/
        begin
          visit_option
          return
        rescue ex : UnknownOption
          raise ex if definitions.unknowns.empty?
        end
      end
      visit_argument
    end

    # :nodoc:
    def visit_terminator
      name = self[0]
      if node = find_with_def(definitions.terminators, self[0]){|df| df.visit(self)}
        parsed_nodes << node
        @index += node[:args].size
      end
    end

    # :nodoc:
    def find_with_def(dfs, name)
      dfs.each do |kv|
        next unless kv[1].matches?(name)
        node = yield kv[1]
        return node if node
      end
      nil
    end

    # :nodoc:
    def visit_concatenated_options
      names = self[0][1..-1].split("").map{|i| "-#{i}"}
      node = Parser.new_node([self[0]])
      names.each do |name|
        if nd = find_with_def(definitions.options, name){|df| df.visit_concatenated(self, name)}
          node[:definitions] << nd[:definitions][0]
        else
          raise UnknownOption.new(self, name)
        end
      end
      parsed_nodes << node
      @index += 1
    end

    # :nodoc:
    def visit_option
      name = self[0]
      if node = find_with_def(definitions.options, name){|df| df.visit(self)}
        parsed_nodes << node
        @index += node[:args].size
      else
        raise UnknownOption.new(self, self[0])
      end
    end

    # :nodoc:
    def visit_argument
      if definitions.unknowns.empty?
        visit_argument2
      else
        visit_unknown
      end
    end

    # :nodoc:
    def visit_argument2
      while @argument_index < definitions.arguments.size
        df = definitions.argument_list[@argument_index]
        unless df.visitable?(self)
          @argument_index += 1
          next
        end
        node = df.visit(self)
        @parsed_nodes << node
        @index += node[:args].size
        return
      end
      arg = self[0]
      @nameless_args << arg
      @parsed_args << arg
      @parsed_nodes << Parser.new_node([arg])
      @index += 1
    end

    # :nodoc:
    def visit_unknown
      node = Parser.new_node(%w(), definitions.unknowns.first[1])
      @parsed_nodes << node
    end

    # :nodoc:
    def [](*args)
      input_args[@index..-1][*args]
    end

    # :nodoc:
    def left
      input_args.size - @index
    end

    # Creates and raises a new `ValidationError` with the *message*.
    def invalidate!(message : String)
      invalidate! ValidationError.new(self, message)
    end

    # :nodoc:
    def invalidate!(ex : ValidationError)
      raise ex
    end
  end
end
