require 'rails_helper'

feature 'Create answer', %q{
        As an authenticated user
        Be able to create a answer
} do

  given(:question) { create( :question )}

  scenario 'Authenticated user creates answer' do
    sign_in(question.user)

    visit question_path(question)
    
    fill_in 'Body', with: 'It\'s my answer'
    click_on 'Create Answer'
    expect(page).to have_content 'Your answer successfully created.'
  end

  scenario 'Authenticated user creates invalid answer' do
    sign_in(question.user)

    visit question_path(question)
    
    click_on 'Create Answer'
    expect(page).to have_content 'Your answer not created.'
  end

  scenario 'Non-Authenticated user creates answer' do
    visit question_path(question)
    
    expect(page).to_not have_content 'New Answer for question'
  end
end
