module Optarg
  abstract class Option < ::Optarg::Definition
    def set_default(result)
      raise "Not implemeted."
    end
  end
end
