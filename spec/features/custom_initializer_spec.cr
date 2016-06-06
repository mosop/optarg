require "../spec_helper"

module Optarg::CustomInitializerFeature
  class The
    def message
      "Someday again!"
    end
  end

  class Model < ::Optarg::Model
    def initialize(argv, @the : The)
      super argv
    end

    on("--goodbye") { raise @the.message }
  end
end

describe "Custom Initializer" do
  it "" do
    argv = %w(--goodbye)
    the = Optarg::CustomInitializerFeature::The.new
    expect_raises(Exception, "Someday again!") { Optarg::CustomInitializerFeature::Model.new(argv, the).parse }
  end
end
