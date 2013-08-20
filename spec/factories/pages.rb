FactoryGirl.define do
  factory :page do
    title { Forgery(:lorem_ipsum).words(5) }
    text { Forgery(:lorem_ipsum).words(20) }
  end
end
