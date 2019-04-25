require 'rails_helper'

feature 'Create subscription' do
  given(:user) { create(:user) }
  given(:question) { create(:question, user: user) }
  given(:subscription) { create(:subscription, user: user, question: question) }

  scenario 'Authenticated user create subscription' do
    sign_in user
    visit question_path(question)

    click_on 'Subscribe'

    expect(current_path).to eq question_path(question)
    expect(page).to_not have_content 'Subscribe'
    expect(page).to have_content 'Unsubscribe'
  end

  scenario 'Authenticated subscribed user tries to create subscription' do
    subscription
    sign_in user
    visit question_path(question)

    expect(page).to_not have_content 'Subscribe'
    expect(page).to have_content 'Unsubscribe'
  end

  scenario 'Non-authenticated user tries to create subscription' do
    visit question_path(question)

    expect(page).to_not have_content 'Subscribe'
  end
end