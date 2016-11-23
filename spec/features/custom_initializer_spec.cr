require "../spec_helper"

module OptargCustomInitializerFeature
  class The
    def message
      "Someday again!"
    end
  end

  class Model < Optarg::Model
    def initialize(argv, @the : The)
      super argv
    end

    on("--goodbye") { raise @the.message }
  end

  it name do
    argv = %w(--goodbye)
    the = The.new
    expect_raises(Exception, "Someday again!") { Model.parse(argv, the) }
  end
end
