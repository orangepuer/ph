require 'rails_helper'

feature 'Edit_question' do
  given(:user) { create(:user) }
  given(:another_user) { create(:user) }
  given(:question) { create(:question, user: user) }

  scenario 'Authenticated user sees link to Cancel', js: true do
    sign_in user

    visit question_path(question)

    expect(page).to have_link 'Edit'
    click_on 'Edit'

    expect(page).to_not have_link 'Edit'
    expect(page).to have_link 'Cancel'
  end

  scenario 'Authenticated user edit question', js: true do
    sign_in user

    visit question_path(question)

    click_on 'Edit'
    fill_in 'Title', with: 'test question'
    fill_in 'Body', with: 'test body'
    click_on 'Update Question'

    expect(page).to_not have_content question.title
    expect(page).to_not have_content question.body
    expect(page).to have_content 'test question'
    expect(page).to have_content 'test body'
    within '.question' do
      expect(page).to_not have_selector 'textarea'
    end
  end

  scenario 'Authenticated user try to edit question other users' do
    sign_in another_user

    visit question_path(question)

    within '.question' do
      expect(page).to_not have_link 'Edit'
    end
  end

  scenario 'Non-authenticated user edit question' do
    visit question_path(question)

    expect(page).to_not have_link 'Edit'
  end
end