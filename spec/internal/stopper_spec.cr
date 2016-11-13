require "../spec_helper"

module OptargInternalStopperFeature
  class ArgumentModel < Optarg::Model
    arg "a", stop: true
    arg "arg"
  end

  class StringModel < Optarg::Model
    string "-s", stop: true
    arg "arg"
  end

  class BoolModel < Optarg::Model
    bool "-b", stop: true
    arg "arg"
  end

  class HandlerModel < Optarg::Model
    on("-h", stop: true) {}
    arg "arg"
  end

  macro test(model, args)
    it {{model}}.name do
      result = {{model}}.parse({{args}})
      result.arg?.should be_nil
      result.unparsed_args.should eq \%w(arg)
    end
  end

  describe name do
    test ArgumentModel, %w(a arg)
    test StringModel, %w(-s s arg)
    test BoolModel, %w(-b arg)
    test HandlerModel, %w(-h arg)
  end
end
