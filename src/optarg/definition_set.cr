module Optarg
  abstract class DefinitionSet
    @items = [] of ::Optarg::Definition
    @options = [] of ::Optarg::Option
    @handlers = [] of ::Optarg::Handler

    getter :items
    getter :options
    getter :handlers

    abstract def base

    def <<(option : ::Optarg::Option)
      @items << option
      @options << option
    end

    def <<(handler : ::Optarg::Handler)
      @items << handler
      @handlers << handler
    end

    def each_set
      current = self
      loop do
        yield current
        current = current.base
        break unless current
      end
    end

    def each
      each_set do |set|
        set.items.each do |i|
          yield i
        end
      end
    end

    # def sets
    #   a = [] of ::Optarg::OptionSet
    #   each_set{|i| a << i}
    #   a
    # end
    #
    # def all
    #   a = [] of ::Optarg::Option
    #   sets.each{|i| a += i.items}
    #   a
    # end
  end
end
