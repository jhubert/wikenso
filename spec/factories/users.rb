# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :user do
    name { Forgery::Name.full_name }
    email { Forgery(:internet).email_address }
    password "foo"
    password_confirmation "foo"
  end
end
