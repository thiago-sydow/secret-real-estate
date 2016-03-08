FactoryGirl.define do
  factory :user_visit, class: 'Visit' do
    visitable_type 'User'
    visit_time { Time.current }
  end

  factory :property_visit, class: 'Visit' do
    visitable_type 'Property'
    visit_time { Time.current }
  end

end
