require 'rails_helper'

feature 'User destroy question' do
  given(:user) { create(:user) }
  given!(:question) { create(:question) }

  scenario 'if user the author of the question' do
    sign_in(question.user)
    visit question_path(question)
    click_on 'Delete'
    expect(page).to have_content 'Question was successfully destroyed.'
  end

  scenario 'if user not the author of the question' do
    sign_in(user)
    visit question_path(question)
    expect(page).to_not have_link 'Delete'
  end
end