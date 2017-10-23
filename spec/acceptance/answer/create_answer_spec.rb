require 'rails_helper'

feature 'Create answer', %q{
        As an authenticated user
        Be able to create a answer
} do

  given(:user) { create(:user) }
  given(:question) { create( :question, title: 'Title', body: 'Body', user_id: user.id )}

  scenario 'Authenticated user creates answer' do
    sign_in(user)

    visit question_path(question)
    click_on 'Answer the Question'
    fill_in 'Body', with: 'It\'s my answer'
    click_on 'Create'
    expect(page).to have_content 'Your answer successfully created.'
  end

  scenario 'Non-Authenticated user creates answer' do
    visit question_path(question)
    click_on 'Answer the Question'

    expect(page).to have_content 'You need to sign in or sign up before continuing.'
  end
end
