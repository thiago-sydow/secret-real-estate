FactoryGirl.define do
  factory :property do
    user
    name "Property example"
    description "Some description"
    property_type :apartment
    goal :rent
    price 200
  end

end
