FactoryGirl.define do
  factory :page_version, class: PaperTrail::Version do
    event "update"
    item { create(:page) }
    item_type "Page"
  end
end
