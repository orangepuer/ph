require 'rails_helper'

feature 'Edit answer' do
  given(:user) { create(:user) }
  given(:another_user) { create(:user) }
  given(:question) { create(:question, user: user) }
  given!(:answer) { create(:answer, question: question, user: user) }

  scenario 'Unauthenticated user try to edit answer' do
    visit question_path(question)

    expect(page).to_not have_link 'Edit'
  end

  describe 'Authenticated user' do
    before do

    end

    scenario 'try to edit his answer', js: true do
      sign_in user
      visit question_path(question)

      within '.answers' do
        expect(page).to have_link 'Edit'

        click_on 'Edit'
        fill_in 'Answer', with: 'edited answer'
        click_on 'Save'

        expect(page).to_not have_content answer.body
        expect(page).to have_content 'edited answer'
        expect(page).to_not have_selector 'textarea'
      end
    end
  end

  scenario 'try to edit answer other users' do
    sign_in another_user
    visit question_path(question)

    within '.answers' do
      expect(page).to_not have_link 'Edit'
    end
  end
end