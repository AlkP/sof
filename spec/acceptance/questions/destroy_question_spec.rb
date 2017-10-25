require 'rails_helper'

feature 'Destroy question', %q{
        As an authenticated user
        Be able to destroy a question
} do

  given(:user) { create(:user) }
  given(:question) { create( :question )}

  scenario 'Authenticated user destroy question' do
    sign_in(question.user)

    visit question_path(question)
    click_on 'Destroy Question'
    expect(page).to have_content 'Your question successfully destroyed.'
    expect(page).to_not have_content question.title
  end

  scenario 'Authenticated user destroy not self question' do
    sign_in(user)

    visit question_path(question)
    expect(page).to_not have_link('Destroy Question', href: question_path(question))
  end

  scenario 'Non-Authenticated user destroy question' do
    visit question_path(question)
    expect(page).to_not have_link('Destroy Question', href: question_path(question))
  end
end