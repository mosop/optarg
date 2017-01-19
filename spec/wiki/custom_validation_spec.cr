require "../spec_helper"

module OptargCustomValidationWikiFeature
  class Hello < Optarg::Model
    arg "smiley"

    Parser.on_validate do |parser, data|
      parser.invalidate! "That's not a smile." if data.smiley != ":)"
    end
  end

  it name do
    expect_raises(Optarg::ValidationError, "That's not a smile.") { Hello.parse %w(:P) }
  end
end
