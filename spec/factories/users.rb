FactoryGirl.define do
  factory :active_user, class: "ActiveUser" do
    password "foo"
    password_confirmation { |u| u.password }
    name { Forgery::Name.full_name }
    email { Forgery(:internet).email_address }

    trait :super_admin do
      role "super_admin"
    end

    trait :normal do
      role "user"
    end
  end

  factory :pending_user, class: "PendingUser" do
    name { Forgery::Name.full_name }
    email { Forgery(:internet).email_address }

    trait :wiki do
      wiki { create(:wiki) }
    end

    trait :invitation do
      invitations { create_list(:user_invitation, 1) }
    end
  end
end
