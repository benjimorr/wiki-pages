FactoryGirl.define do
  factory :wiki do
    title "MyString"
    body "MyTextMustBeAtLeast20Characters"
    private false
    user
  end
end
