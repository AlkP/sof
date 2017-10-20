FactoryGirl.define do
  factory :question do
    title "MyString"
    body "MyText"
  end

  factory :question_invalid, class: Question do
    title nil
    body nil
  end
end
