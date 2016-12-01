require "../spec_helper"

module OptargInheritanceFeature
  abstract class Animal < Optarg::Model
    bool "--sleep"
  end

  class Cat < Animal
    bool "--mew"
  end

  class Dog < Animal
    bool "--woof"
  end

  it name do
    Cat.parse(%w()).responds_to?(:sleep?).should be_true
    Dog.parse(%w()).responds_to?(:sleep?).should be_true
  end
end
