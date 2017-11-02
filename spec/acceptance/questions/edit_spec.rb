require 'rails_helper'

feature 'User edit question' do
  given!(:question) { create(:question) }
  before { sign_in(question.user) }
  before { visit edit_question_path(question) }

  scenario 'with valid attributes' do
    fill_in 'title', with: 'New title'
    fill_in 'body', with: 'It\'s my new body question'
    click_on 'Update Question'

    expect(page).to have_content 'Question was successfully updated.'
    expect(page).to have_content 'New title'
    expect(page).to have_content 'It\'s my new body question'
  end

  scenario 'with invalid attributes' do
    fill_in 'title', with: nil
    fill_in 'body', with: nil
    click_on 'Update Question'

    expect(page).to have_content 'Title can\'t be blank'
    expect(page).to have_content 'Body can\'t be blank'
    expect(current_path).to eq question_path(question)
  end

end