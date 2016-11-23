module Optarg::Util
  struct Variable(T)
    @value : T?

    def value
      @value
    end

    def value=(value)
      @value = value
    end
  end
end
