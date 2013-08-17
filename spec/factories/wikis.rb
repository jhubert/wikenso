# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :wiki do
    name { Forgery(:name).company_name.downcase }

    trait :users_attributes do
      users_attributes { { "0" => FactoryGirl.attributes_for(:user) } }
    end

  end
end
