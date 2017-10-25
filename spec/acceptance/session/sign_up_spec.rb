require 'rails_helper'

feature 'User sign up', %q{
        In order to be able to ask a question
        As an user
        I want to be able to sign in
} do

  given(:user) { create(:user) }

  scenario 'User try to sign up' do
    # sign_in(user)
    visit new_user_registration_path
    fill_in 'Email', with: 'user@test.com'
    fill_in 'Password', with: '12345678'
    fill_in 'Password confirmation', with: '12345678'
    click_on 'Sign up'

    # save_and_open_page
    expect(page).to have_content 'Welcome! You have signed up successfully. '
    expect(current_path).to eq root_path
  end

  scenario 'User try to sign up' do
    sign_in(user)

    click_on 'Sign Out'

    # save_and_open_page
    expect(page).to have_content 'Signed out successfully. '
    expect(current_path).to eq root_path
  end
end