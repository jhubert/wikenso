FactoryGirl.define do
  factory :active_user, class: "ActiveUser" do
    password "foo"
    password_confirmation { |u| u.password }
    name { Forgery::Name.full_name }
    email { Forgery(:internet).email_address }
  end

  factory :pending_user, class: "PendingUser" do
    name { Forgery::Name.full_name }
    email { Forgery(:internet).email_address }
    password "foo"
    password_confirmation { |u| u.password }

    trait :invitation do
      invitations { create_list(:user_invitation, 1) }
    end
  end

end
