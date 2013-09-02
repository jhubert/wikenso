FactoryGirl.define do
  factory :welcome_page do
    title { Forgery(:lorem_ipsum).words(5) }
    text { Forgery(:lorem_ipsum).words(20) }
  end
end
