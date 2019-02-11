require 'rails_helper'

feature 'Edit_question' do
  given(:user) { create(:user) }
  given(:question) { create(:question, user: user) }
  scenario 'Authenticated user edit question' do
    sign_in user

    visit question_path(question)

    expect(page).to have_link 'Edit'

    click_on 'Edit'
    fill_in 'Title', with: 'test question'
    fill_in 'Body', with: 'test body'
    click_on 'Update Question'

    expect(page).to have_content 'Your question successfully updated'
  end

  scenario 'Non-authenticated user edit question' do
    visit question_path(question)

    expect(page).to_not have_link 'Edit'
  end
end