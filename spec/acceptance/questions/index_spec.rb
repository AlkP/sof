require 'rails_helper'

feature 'User sees list questions' do
  given!(:user) { create(:user) }
  given!(:questions) { create_list(:question, 25) }

  scenario 'Non-Registered user sees list questions' do
    visit root_path

    questions.first(15).each do |q|
      expect(page).to have_link q.title
    end

    questions.last(10).each do |q|
      expect(page).to_not have_link q.title
    end
  end

  scenario 'Registered user sees list questions' do
    sign_in(user)
    visit root_path

    questions.first(15).each do |q|
      expect(page).to have_link q.title
    end

    questions.last(10).each do |q|
      expect(page).to_not have_link q.title
    end
  end
end