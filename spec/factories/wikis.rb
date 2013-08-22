# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :wiki do
    subdomain { Forgery(:name).company_name.downcase }

    trait :users_attributes do
      users_attributes { { "0" => attributes_for(:user) } }
    end

    trait :single_page do
      pages { FactoryGirl.create_list(:page, 1) }
    end

  end
end
