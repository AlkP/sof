require 'rails_helper'

feature 'Show question', %q{
        Any user
        Be able to show a question
} do

  given(:user) { create(:user) }
  given(:question) { create( :question, title: 'Title', body: 'Body', user_id: user.id )}

  scenario 'Authenticated user show question' do
    sign_in(user)

    visit question_path(question)
    expect(page).to have_content "Question: '#{question.title}'"
  end

  scenario 'Non-Authenticated user show question' do
    sign_in(user)

    visit question_path(question)
    expect(page).to have_content "Question: '#{question.title}'"
  end
end