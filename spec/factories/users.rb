FactoryGirl.define do
  factory :user do
    name "サーバルちゃん"
    email "cat@example.com"
    password "foobaa"
    password_confirmation "foobaa"
    admin true
    department
  end
end
