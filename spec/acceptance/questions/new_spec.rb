require 'rails_helper'

feature 'User create new question' do
  given(:user) { create(:user) }
  before { sign_in(user) }

  scenario 'with valid attributes' do
    visit new_question_path
    fill_in 'title', with: 'New title'
    fill_in 'body', with: 'It\'s my question'
    click_on 'Create Question'

    expect(page).to have_content 'Question was successfully created.'
    expect(page).to have_content 'New title'
    expect(page).to have_content 'It\'s my question'
  end

  scenario 'with invalid attributes' do
    visit new_question_path
    fill_in 'title', with: nil
    fill_in 'body', with: nil
    click_on 'Create Question'

    expect(page).to have_content 'Question was not created.'
  end
end
