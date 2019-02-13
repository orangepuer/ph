require 'rails_helper'

feature 'Create answer' do
  given(:user) { create (:user) }
  given(:question) { create(:question, user: user) }

  scenario 'Authenticated user create answer', js: true do
    sign_in user
    visit question_path(question)

    fill_in 'Your answer', with: 'My answer'
    click_on 'Create'

    expect(current_path).to eq question_path(question)
    within '.answers' do
      expect(page).to have_content 'My answer'
    end
  end

  scenario 'Non-authenticated user create answer', js: true do
    visit question_path(question)

    expect(page).to have_link 'Sign in to answer the question'
  end
end