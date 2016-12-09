require "../spec_helper"

module OptargBuiltinValidationsWikiFeature
  module Inclusion
    class SomewhereWarm < Optarg::Model
      arg "island", any_of: %w(tahiti okinawa hawaii)
    end

    it name do
      expect_raises(Optarg::Definitions::StringArgument::Validations::Inclusion::Error, "The island argument must be one of tahiti, okinawa, hawaii.") {
        SomewhereWarm.parse %w(gotland)
      }
    end
  end

  module ElementInclusion
    class EuropeanWallet < Optarg::Model
      arg_array "bill", any_item_of: %w(€5 €10 €20 €50 €100 €200 €500)
    end

    it name do
      expect_raises(Optarg::Definitions::StringArrayArgument::Validations::ElementInclusion::Error, "Each element of the bill argument must be one of €5, €10, €20, €50, €100, €200, €500.") {
        EuropeanWallet.parse %w(€10 $50 €100)
      }
    end
  end

  module MinimumLengthOfArray
    class TeamOfCanoePolo < Optarg::Model
      arg_array "member", min: 5
    end

    it name do
      expect_raises(Optarg::Definitions::StringArrayArgument::Validations::MinimumLengthOfArray::Error, "The count of the member arguments is 4, but 5 or more is expected.") {
        TeamOfCanoePolo.parse %w(freddie brian roger john)
      }
    end
  end

  module Existence
    class GoToProm < Optarg::Model
      string "--dress"
      string "--partner", required: true
    end

    it name do
      expect_raises(Optarg::Definitions::StringOption::Validations::Existence::Error, "The --partner option is required.") {
        GoToProm.parse %w(--dress brand-new-tuxedo)
      }
    end
  end
end
