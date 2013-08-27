FactoryGirl.define do
  factory :user_invitation do
    code { SecureRandom.hex }
    user { create(:pending_user) }
  end
end
