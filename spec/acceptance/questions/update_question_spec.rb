require 'rails_helper'

feature 'Update question', %q{
        As an authenticated user
        Be able to update a question
} do

  given(:user) { create(:user) }
  given(:question) { create( :question )}

  scenario 'Authenticated user update question' do
    sign_in(question.user)
    visit question_path(question)
    expect(page).to have_link('Edit Question', href: edit_question_path(question))
    click_on 'Edit Question'
    expect(page).to have_content "Update '#{question.title}' Question"
  end

  scenario 'Authenticated user update not self question' do
    sign_in(user)
    visit question_path(question)
    expect(page).to_not have_link('Edit Question', href: edit_question_path(question))
  end

  scenario 'Non-Authenticated user update question' do
    visit question_path(question)
    expect(page).to_not have_link('Edit Question', href: edit_question_path(question))
  end
end