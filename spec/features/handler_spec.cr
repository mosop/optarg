require "../spec_helper"

module OptargHandlerFeature
  class Model < Optarg::Model
    on("--goodbye") { goodbye! }

    def goodbye!
      raise "Goodbye, world!"
    end
  end

  it name do
    expect_raises(Exception, "Goodbye, world!") { Model.parse(%w(--goodbye)) }
  end
end
