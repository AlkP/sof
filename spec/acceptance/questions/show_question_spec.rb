require 'rails_helper'

feature 'Show question', %q{
        Any user
        Be able to show a question
} do

  given(:question) { create( :question )}

  scenario 'Authenticated user show question' do
    sign_in(question.user)

    visit question_path(question)
    expect(page).to have_content "Question: '#{question.title}'"
    expect(page).to have_content "'#{question.body}'"
    expect(page).to have_content 'New Answer for question'
  end

  scenario 'Non-Authenticated user show question' do
    sign_in(question.user)
    visit question_path(question)
    expect(page).to have_content "Question: '#{question.title}'"
  end
end