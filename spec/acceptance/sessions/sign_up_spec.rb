require 'rails_helper'

feature 'User sign up' do
  given(:user) { create(:user) }

  scenario 'Non-Registered user try to sign in' do
    visit new_user_registration_path
    fill_in 'Email', with: 'user@test.com'
    fill_in 'Password', with: '12345678'
    fill_in 'Password confirmation', with: '12345678'
    click_on 'Sign up'
    expect(page).to have_content 'Welcome! You have signed up successfully.'
    expect(current_path).to eq root_path
  end

  scenario 'Authorized user try to sign up' do
    sign_in(user)
    visit new_user_registration_path
    expect(page).to have_content 'You are already signed in.'
    expect(current_path).to eq root_path
  end

  scenario 'Non-Registered user try to log in' do
    visit new_user_session_path
    fill_in 'Email', with: 'wrong@test.com'
    fill_in 'Password', with: '12345678'
    click_on 'Log in'
    expect(page).to have_content 'Invalid Email or password.'
    expect(current_path).to eq new_user_session_path
  end

  scenario 'Authorized user try to sign up' do
    sign_in(user)
    visit new_user_session_path
    expect(page).to have_content 'You are already signed in.'
    expect(current_path).to eq root_path
  end
end