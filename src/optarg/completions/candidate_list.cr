module Optarg::Completions
  class CandidateList < Completion
    getter candidates = [] of CompletionCandidate

    def to_completion_string
      candidates.map{|i| i.to_completion_string}.join(" ")
    end
  end
end
