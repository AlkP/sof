require 'rails_helper'

feature 'User create new question' do
  given(:question) { create(:question) }
  before { sign_in(question.user) }
  before { visit question_path(question) }

  scenario 'with valid attributes' do
    fill_in 'body', with: 'It\'s my answer'
    click_on 'Create Answer'

    expect(page).to have_content 'It\'s my answer'
    expect(page).to have_content 'Answer was successfully created.'
    expect(current_path).to eq question_path(question)
  end

  scenario 'with invalid attributes' do
    fill_in 'body', with: nil
    click_on 'Create Answer'

    expect(page).to have_content 'Answer was not created.'
    expect(current_path).to eq question_path(question)
  end
end