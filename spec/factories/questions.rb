FactoryGirl.define do
  factory :question do
    sequence(:title) { |n| "Title question ##{n}" }
    sequence(:body) { |n| "Body question ##{n}" }
    user
  end

  factory :question_invalid, class: Question do
    title nil
    body nil
  end
end
