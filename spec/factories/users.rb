FactoryGirl.define do
  factory :user do
    name { Forgery::Name.full_name }
    email { Forgery(:internet).email_address }
    password "foo"
    password_confirmation "foo"
  end

  factory :active_user, class: "ActiveUser" do
    name { Forgery::Name.full_name }
    email { Forgery(:internet).email_address }
    password "foo"
    password_confirmation "foo"
  end

  factory :pending_user, class: "PendingUser" do
    name { Forgery::Name.full_name }
    email { Forgery(:internet).email_address }
    password "foo"
    password_confirmation "foo"
  end
end
