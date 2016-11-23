require "../spec_helper"

module OptargBuiltinValidationsWikiFeature
  module Inclusion
    class Trip < Optarg::Model
      arg "somewhere_warm", any_of: %w(tahiti okinawa hawaii)
    end

    it name do
      expect_raises(Optarg::Definitions::StringArgument::Validations::Inclusion::Error, "The somewhere_warm argument must be one of tahiti, okinawa, hawaii.") { Trip.parse %w(gotland) }
    end
  end
end
