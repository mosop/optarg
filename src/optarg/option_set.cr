module Optarg
  abstract class OptionSet
    @items = [] of ::Optarg::Option

    getter :items

    abstract def base

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

    def sets
      a = [] of ::Optarg::OptionSet
      each_set{|i| a << i}
      a
    end

    def all
      a = [] of ::Optarg::Option
      sets.each{|i| a += i.items}
      a
    end
  end
end
