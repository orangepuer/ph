require 'rails_helper'

feature 'Create question' do
  given(:user) { create(:user) }

  scenario 'Authenticated user creates question' do
    sign_in user

    visit questions_path
    click_on 'Ask question'
    fill_in 'Title', with: 'test question'
    fill_in 'Body', with: 'test text'
    click_on 'Create'

    expect(page).to have_content 'Your question successfully created'
  end

  scenario 'Non-authenticated user creates question' do
    visit questions_path
    click_on 'Ask question'

    expect(page).to have_content 'You need to sign in or sign up before continuing.'
  end

  context 'Multiple sessions' do
    scenario 'Users can sees in real time questions created of other users', js: true do
      Capybara.using_session 'user' do
        sign_in user
        visit new_question_path
      end

      Capybara.using_session 'guest' do
        visit questions_path
      end

      Capybara.using_session 'user' do
        fill_in 'Title', with: 'Real time question title'
        fill_in 'Body', with: 'Real time question body'
        click_on 'Create Question'

        expect(page).to have_content 'Real time question title'
        expect(page).to have_content 'Real time question body'
      end

      Capybara.using_session 'guest' do
        expect(page).to have_link 'Real time question title', href: '/questions/1'
      end
    end
  end
end