require "../spec_helper"

module OptargAccessingValuesWikiFeature
  module AccessingNamedValues
    module ValueAccessors
      module Section1
        class Model < Optarg::Model
          string "-s"
          bool "-b"
          array "-a"
          arg "arg"
          arg_array "args"
        end

        it name do
          result = Model.parse(%w(-s foo -b -a bar -a baz blep blah boop))
          result.s.should eq "foo"
          result.b?.should be_true
          result.a.should eq ["bar", "baz"]
          result.arg.should eq "blep"
          result.args.should eq ["blah", "boop"]
        end
      end

      module Section2
        class Model < Optarg::Model
          bool "-b"
        end

        it name do
          result = Model.parse(%w())
          result.b?.should be_false
        end
      end

      module Section3
        class Model < Optarg::Model
          string "-s"
        end

        it name do
          result = Model.parse(%w())
          expect_raises(KeyError) { result.s }
          result.s?.should be_nil
        end
      end

      module Section4
        class Model < Optarg::Model
          bool %w(-f --force)
        end

        it name do
          result = Model.parse(%w(--force))
          result.f?.should be_true
          result.force?.should be_true
        end
      end
    end

    module ValueHashes
      module Section1
        class Model < Optarg::Model
          string "-s"
          bool "-b"
          array "-a"
          arg "arg"
          arg_array "args"
        end

        it name do
          result = Model.parse(%w(-s foo -b -a bar -a baz blep blah boop))
          result[String].should eq({"-s" => "foo", "arg" => "blep"})
          result[Bool].should eq({"-b" => true})
          result[Array(String)].should eq({"-a" => ["bar", "baz"], "args" => ["blah", "boop"]})
        end
      end

      module Section2
        class Model < Optarg::Model
          bool %w(-f --force)
        end

        it name do
          result = Model.parse(%w(--force))
          result[Bool]["-f"].should be_true
          expect_raises(KeyError) { result[Bool]["--force"] }
        end
      end
    end

    module AvoidingOverridingMethods
      class Model < Optarg::Model
        string "--class"
      end

      it name do
        result = Model.parse(%w(--class foo))
        result.class.should eq Model
        result[String]["--class"].should eq "foo"
      end
    end
  end

  module AccessingNamelessArguments
    class Model < Optarg::Model
      arg "arg"
    end

    it name do
      result = Model.parse(%w(foo bar baz))
      result.arg.should eq "foo"
      result.nameless_args.should eq ["bar", "baz"]
    end
  end

  module AccessingUnparsedArguments
    module Section1
      class Model < Optarg::Model
        arg "arg", stop: true
      end

      it name do
        result = Model.parse(%w(foo bar baz))
        result.arg.should eq "foo"
        result.unparsed_args.should eq ["bar", "baz"]
      end
    end

    module Section2
      class Model < Optarg::Model
        terminator "--"
      end

      it name do
        result = Model.parse(%w(foo -- bar baz))
        result.nameless_args.should eq ["foo"]
        result.unparsed_args.should eq ["bar", "baz"]
      end
    end
  end
end
