require 'rails_helper'

feature 'User sees list questions' do
  given!(:user) { create(:user) }
  given!(:question) { create(:question) }
  given!(:question2) { create(:question) }
  given!(:answers) { create_list(:answer, 5, question: question, user: question.user) }
  given!(:answers2) { create_list(:answer, 5, question: question2) }
  given!(:answers3) { create_list(:answer, 5, question: question, user: question2.user) }

  scenario 'Non-Registered user sees question and answers (only question answers), but don\'t sees form for new answer' do
    visit question_path(question)

    expect(page).to have_content question.title
    expect(page).to have_content question.body

    list_of_answers_is_available(answers)
    answers_list_is_not_available(answers2)
    list_of_answers_is_available(answers3)

    expect(page).to_not have_button 'Create Answer'
    expect(page).to_not have_link 'Edit'
    expect(page).to_not have_link 'Delete'
  end

  scenario 'Registered user sees question and answers (only question answers), and see form for new answer' do
    sign_in(question.user)
    visit question_path(question)

    expect(page).to have_content question.title
    expect(page).to have_content question.body

    list_of_my_answers_is_available(answers)
    answers_list_is_not_available(answers2)
    list_of_answers_is_available(answers3)

    expect(page).to have_button 'Create Answer'
    expect(page).to have_link 'Edit'
    expect(page).to have_link 'Delete'

  end

end