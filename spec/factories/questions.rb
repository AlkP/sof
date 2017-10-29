FactoryGirl.define do
  factory :question do
    sequence(:title) { |n| "Title question ##{n}" }
    sequence(:body) { |n| "Body question ##{n}" }
    user

    factory :question_invalid do
      title nil
      body nil
    end
  end
end
