module Optarg::CompletionCandidates
  class String < CompletionCandidate
    getter string : ::String

    def initialize(@string)
    end

    def to_completion_string
      string
    end
  end
end
