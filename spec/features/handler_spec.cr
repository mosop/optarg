require "../spec_helper"

module Optarg::HandlerFeature
  class Model < ::Optarg::Model
    on("--goodbye") { goodbye! }

    def goodbye!
      raise "Goodbye, world!"
    end
  end
end

describe "Handler" do
  it "" do
    expect_raises(Exception, "Goodbye, world!") { Optarg::HandlerFeature::Model.parse(%w(--goodbye)) }
  end
end
