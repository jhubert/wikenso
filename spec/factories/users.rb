# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :user do
    name { Forgery::Name.full_name }
    password "foo"
    password_confirmation "foo"
  end
end
