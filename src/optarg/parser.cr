module Optarg
  abstract class Parser
    ::Callback.enable
    define_callback_group :parse
    define_callback_group :validate

    alias Node = NamedTuple(args: Array(String), definitions: Array(Definitions::Base))

    getter input_args : Array(String)
    getter parsed_nodes = [] of Node

    @data = Util::Variable(Model).new
    @options = Util::Variable(OptionValueContainer).new
    @args = Util::Variable(ArgumentValueContainer).new

    @argument_index = 0
    getter index = 0

    def initialize(data, @input_args)
      @data.value = data
    end

    def self.new_node(args = %w(), *definitions)
      node = {args: args, definitions: [] of Definitions::Base}
      definitions.each do |df|
        node[:definitions] << df
      end
      node
    end

    @definitions : DefinitionSet?
    def definitions
      @definitions ||= data.class.definitions
    end

    def stopped?
      return false if parsed_nodes.size == 0
      return parsed_nodes.last[:definitions].any?{|i| i.stops? || i.terminates?}
    end

    @unparsed_args : Array(String)?
    def unparsed_args
      @unparsed_args ||= %w()
    end

    before_parse do |o|
      o.definitions.all.each do |kv|
        kv[1].run_callbacks_for_before_parse(o) {}
      end
    end

    after_parse do |o|
      o.definitions.all.each do |kv|
        kv[1].run_callbacks_for_after_parse(o) {}
      end
    end

    on_validate do |o|
      o.definitions.value_validators.each do |kv|
        kv[1].validate_value(o)
      end
    end

    def parse
      run_callbacks_for_parse do
        resume
      end
      run_callbacks_for_validate do
      end
    end

    def eol?
      @index == @input_args.size
    end

    def resume
      until eol? || stopped?
        visit
      end
    ensure
      @unparsed_args = self[0..-1] if left > 0
      @index = @input_args.size
    end

    def visit
      arg = self[0]
      if visit_terminator
      elsif arg =~ /^-\w\w/
        visit_concatenated_options
      elsif arg =~ /^-/
        visit_option
      else
        visit_argument
      end
    end

    def visit_terminator
      name = self[0]
      if node = find_with_def(definitions.terminators, self[0]){|df| df.visit(self)}
        parsed_nodes << node
        @index += node[:args].size
      end
    end

    def find_with_def(dfs, name)
      dfs.each do |kv|
        next unless kv[1].matches?(name)
        node = yield kv[1]
        return node if node
      end
      nil
    end

    def visit_concatenated_options
      names = self[0][1..-1].split("").map{|i| "-#{i}"}
      node = Parser.new_node([self[0]])
      names.each do |name|
        if nd = find_with_def(definitions.concatenation_visitors, name){|df| df.visit_concatenated(self, name)}
          node[:definitions] << nd[:definitions][0]
        else
          raise UnknownOption.new(self, name)
        end
      end
      parsed_nodes << node
      @index += 1
    end

    def visit_option
      name = self[0]
      if node = find_with_def(definitions.option_visitors, name){|df| df.visit(self)}
        parsed_nodes << node
        @index += node[:args].size
      else
        raise UnknownOption.new(self, self[0])
      end
    end

    def visit_argument
      arg = self[0]
      if @argument_index < definitions.arguments.size
        df = definitions.argument_values[@argument_index]
        args.__named[df.key] = arg
        args.__values << arg
        @parsed_nodes << Parser.new_node([arg], df)
        @argument_index += 1
      else
        args.__nameless << arg
        args.__values << arg
        @parsed_nodes << Parser.new_node([arg])
      end
      @index += 1
    end

    def [](*args)
      @input_args[@index..-1][*args]
    end

    def left
      @input_args.size - @index
    end

    def invalidate!(message : String)
      invalidate! ValidationError.new(self, message)
    end

    def invalidate!(ex : ValidationError)
      raise ex
    end
  end
end
