module Optarg
  class Model
    macro terminator(string)
      @@__self_terminators[{{string}}] = ::Optarg::Terminator.new({{string}})
    end
  end
end
