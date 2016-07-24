module Optarg
  abstract class Completion
    def candidates : Array(CompletionCandidate)
      raise "Should never be called."
    end
  end
end
