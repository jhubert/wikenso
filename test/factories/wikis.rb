# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :wiki do
    name { Forgery(:name).company_name.downcase }
  end
end
