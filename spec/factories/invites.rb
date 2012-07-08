# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :invite do
    token "MyString"
    invited_by "MyString"
    invited_by_type "MyString"
    invited_for "MyString"
    invited_for_type "MyString"
  end
end
