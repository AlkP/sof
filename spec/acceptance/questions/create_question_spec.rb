require 'rails_helper'

feature 'Create question', %q{
        As an authenticated user
        Be able to create a question
} do

  given(:user) { create(:user) }

  scenario 'Authenticated user creates question' do
    sign_in(user)

    visit questions_path
    click_on 'Ask Question'
    fill_in 'Title', with: 'My question'
    fill_in 'Body', with: 'It\'s my question'
    click_on 'Create'
    expect(page).to have_content 'Your question successfully created.'
  end

  scenario 'Non-Authenticated user creates question' do
    visit questions_path
    click_on 'Ask Question'

    expect(page).to have_content 'You need to sign in or sign up before continuing.'
  end
end
# question = build(:question, user)