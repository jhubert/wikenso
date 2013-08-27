FactoryGirl.define do
  factory :active_user, class: "ActiveUser" do
    name { Forgery::Name.full_name }
    email { Forgery(:internet).email_address }
    password "foo"
    password_confirmation "foo"
    after(:build) { |u| u.password_confirmation = u.password }
  end

  factory :pending_user, class: "PendingUser" do
    name { Forgery::Name.full_name }
    email { Forgery(:internet).email_address }
    password "foo"
    password_confirmation "foo"
    after(:build) { |u| u.password_confirmation = u.password }
  end

end
