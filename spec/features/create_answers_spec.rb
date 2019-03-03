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

  scenario 'User try to create invalid answer', js: true do
    sign_in user
    visit question_path(question)

    click_on 'Create'

    expect(page).to have_content "Body can't be blank"
  end

  scenario 'Non-authenticated user create answer', js: true do
    visit question_path(question)

    expect(page).to have_link 'Sign in to answer the question'
  end

  context 'Multiple sessions' do
    scenario 'User sees in real time the answers created of other users', js: true do
      Capybara.using_session('user') do
        sign_in user
        visit question_path(question)
      end

      Capybara.using_session('guest') do
        visit question_path(question)
      end

      Capybara.using_session('user') do
        fill_in 'Your answer', with: 'Real time answer'
        click_on 'Create'

        expect(page).to have_content 'Real time answer'
      end

      Capybara.using_session('guest') do
        expect(page).to have_content 'Real time answer'
      end
    end
  end
end