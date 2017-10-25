FactoryGirl.define do
  factory :answer do
    sequence(:body) { |n| "MyAnswer #{n}" }
    question
    user
  end
end
