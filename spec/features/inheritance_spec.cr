require "../spec_helper"

module Optarg::InheritanceFeature
  class Animal < ::Optarg::Model
    bool "--sleep"
  end

  class Cat < Animal
    bool "--mew"
  end

  class Dog < Animal
    bool "--woof"
  end
end

describe "Inheritance" do
  it "" do
    Optarg::InheritanceFeature::Cat.parse(%w()).responds_to?(:sleep?).should be_true
    Optarg::InheritanceFeature::Dog.parse(%w()).responds_to?(:sleep?).should be_true
  end
end
