require 'rails_helper'

feature 'Create comments' do
  given(:user) { create(:user) }
  given(:question) { create(:question, user: user) }
  given!(:answer) { create(:answer, user: user, question: question) }

  scenario 'Authenticated user create comments to question', js: true do
    sign_in user
    visit question_path(question)

    within '.question' do
      fill_in 'Comment', with: 'New comment to question'
      click_on 'Post'

      expect(current_path).to eq question_path(question)
      expect(page).to have_content 'New comment to question'
    end
  end

  scenario 'Authenticated user create comments to answer', js: true do
    sign_in user
    visit question_path(question)

    within '.answers' do
      fill_in 'Comment', with: 'New comment to answer'
      click_on 'Post'

      expect(current_path).to eq question_path(question)
      expect(page).to have_content 'New comment to answer'
    end
  end

  scenario 'Non-authenticated user try to create comments to question', js: true do
    visit question_path(question)

    within '.question' do
      expect(page).to_not have_selector 'textarea'
    end
  end

  scenario 'Non-authenticated user try to create comments to answer', js: true do
    visit question_path(question)

    within '.answers' do
      expect(page).to_not have_selector 'textarea'
    end
  end
end
