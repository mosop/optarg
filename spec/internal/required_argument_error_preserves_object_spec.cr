require "../spec_helper"

module OptargInternalRequiredArgumentErrorPreservesObjectFeature
  class Model < Optarg::Model
    arg "arg1", required: true
  end

  it name do
    error = nil
    begin
      Model.parse %w()
    rescue ex
      error = ex
    ensure
    end
    error.as(Optarg::Definitions::StringArgument::Validations::Required::Error).argument.should be Model.definitions.arguments["arg1"]
  end
end
