require 'rails_helper'

feature 'Delete subscription' do
  given(:user) { create(:user) }
  given(:question) { create(:question, user: user) }
  given(:subscription) { create(:subscription, user: user, question: question) }

  scenario 'Authenticated subscribed user delete subscription' do
    subscription
    sign_in user
    visit question_path(question)

    click_on 'Unsubscribe'

    expect(current_path).to eq question_path(question)
    expect(page).to_not have_content 'Unsubscribe'
    expect(page).to have_content 'Subscribe'
  end

  scenario 'Authenticated unsubscribed user tries delete subscription' do
    sign_in user
    visit question_path(question)

    expect(page).to_not have_content 'Unsubscribe'
    expect(page).to have_content 'Subscribe'
  end

  scenario 'Non-authenticated user tries delete subscription' do
    visit question_path(question)

    expect(page).to_not have_content 'Unsubscribe'
  end
end