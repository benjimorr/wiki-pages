FactoryGirl.define do
    pw = "mypassword"

    factory :user do
        name "Example Name"
        sequence(:email){|n| "user#{n}@factory.com"}
        password pw
        password_confirmation pw
    end
end
