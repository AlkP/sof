FactoryGirl.define do
  sequence :title do |n|
    "Title question №#{n}"
  end

  sequence :body do |n|
    "Body question №#{n}"
  end

  factory :question do
    title
    body
  end

  factory :question_invalid, class: Question do
    title nil
    body nil
  end
end
