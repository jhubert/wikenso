FactoryGirl.define do
  factory :draft_page do
    title { Forgery(:lorem_ipsum).words(5) }
    text { Forgery(:lorem_ipsum).words(20) }

    trait :page do
      page { create(:page) }
    end
  end
end
