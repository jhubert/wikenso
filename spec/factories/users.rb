FactoryGirl.define do
  factory :user do
    name { Forgery::Name.full_name }
    email { Forgery(:internet).email_address }
    password "foo"
    password_confirmation "foo"

    factory :active_user, class: "ActiveUser" do
    end

    factory :pending_user, class: "PendingUser" do
    end
  end
end
