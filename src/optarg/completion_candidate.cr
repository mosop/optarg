module Optarg
  abstract class CompletionCandidate
    def string : String
      raise "Should never be called."
    end

    def to_completion_string : String
      raise "Should never be called."
    end
  end
end
