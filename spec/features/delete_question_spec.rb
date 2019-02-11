require 'rails_helper'

feature 'Delete question' do
  given(:user) { create(:user) }
  given(:question) { create(:question, user: user) }

  scenario 'Authenticate user delete question' do
    sign_in user

    visit question_path(question)
    click_on 'Delete'

    expect(current_path).to eq questions_path
    expect(page).to have_content 'You question successfully deleted'
  end

  scenario 'Non-authenticated user delete question' do
    visit question_path(question)

    expect(page).to_not have_link 'Delete'
  end
end