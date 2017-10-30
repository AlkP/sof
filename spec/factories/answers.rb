FactoryGirl.define do
  factory :answer do
    sequence(:body) { |n| "MyAnswer ##{n}" }
    question
    user

    factory :answer_invalid do
      body nil
    end
  end
end
