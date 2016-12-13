module Optarg
  abstract class Parser
    ::Callback.enable
    define_callback_group :validate

    alias Node = NamedTuple(args: Array(String), definitions: Array(Definitions::Base))

    getter parsed_nodes = [] of Node

    @data = Util::Var(Model).new
    @options = Util::Var(OptionValueContainer).new
    @args = Util::Var(ArgumentValueContainer).new

    @argument_index = 0
    getter index = 0

    def initialize(data)
      @data.var = data
    end

    def input_args
      data.__argv
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

    on_validate do |o|
      o.definitions.values.each do |kv|
        kv[1].validate(o)
      end
    end

    def parse
      definitions.all.each do |kv|
        kv[1].initialize_before_parse(self)
      end
      resume
      definitions.all.each do |kv|
        kv[1].initialize_after_parse(self)
      end
      run_callbacks_for_validate do
      end
    end

    def eol?
      @index == input_args.size
    end

    def resume
      until eol? || stopped?
        visit
      end
    ensure
      @unparsed_args = self[0..-1] if left > 0
      @index = input_args.size
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
        if nd = find_with_def(definitions.options, name){|df| df.visit_concatenated(self, name)}
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
      if node = find_with_def(definitions.options, name){|df| df.visit(self)}
        parsed_nodes << node
        @index += node[:args].size
      else
        raise UnknownOption.new(self, self[0])
      end
    end

    def visit_argument
      while @argument_index < definitions.arguments.size
        df = definitions.argument_list[@argument_index]
        unless df.visitable?(self)
          @argument_index += 1
          next
        end
        node = df.visit(self)
        parsed_nodes << node
        @index += node[:args].size
        return
      end
      arg = self[0]
      args.__nameless << arg
      args.__values << arg
      @parsed_nodes << Parser.new_node([arg])
      @index += 1
    end

    def [](*args)
      input_args[@index..-1][*args]
    end

    def left
      input_args.size - @index
    end

    def invalidate!(message : String)
      invalidate! ValidationError.new(self, message)
    end

    def invalidate!(ex : ValidationError)
      raise ex
    end
  end
end
