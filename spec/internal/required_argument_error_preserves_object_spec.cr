require "../spec_helper"

module OptargRequiredArgumentErrorPreservesObjectFeature
  class Model < Optarg::Model
    arg "arg1", required: true
  end

  it name do
    error = nil
    begin
      Model.parse %w()
      raise "no error"
    rescue ex
      error = ex
    end
    error.as(Optarg::RequiredArgumentError).argument.should be Model.__arguments["arg1"]
  end
end
