module Optarg
  class Model
    macro terminator(string)
      @@__terminator = ::Optarg::Terminator.new({{string}})
    end
  end
end
