module Optarg::Completions
  class CandidateList < Completion
    getter candidates = [] of CompletionCandidate
  end
end
