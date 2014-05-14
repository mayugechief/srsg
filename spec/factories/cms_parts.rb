# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :cms_part, :class => 'Cms::Part' do
    state  "public"
    name   "テストフッター"
    filename "foot.part.html"
    depth  2
    route  "cms/free"
    mobile_view  "show"
  end
end
