module Optarg::CompletionCandidates
  class String < CompletionCandidate
    getter string : ::String

    def initialize(@string)
    end
  end
end
