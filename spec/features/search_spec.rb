require 'sphinx_helper'

RSpec.feature 'Search' do
  given(:user) { create(:user, email: 'user@user.com') }
  given(:question) { create(:question, user: user) }
  given!(:answer) { create(:answer, user: user, question: question) }
  given!(:comment) { create(:comment, user: user, commentable: question) }

  scenario 'User can search by questions', js: true do
    visit search_path

    ThinkingSphinx::Test.run do
      select 'вопросы', from: 'Search by'
      fill_in 'Search query', with: 'MyString'
      click_on 'Найти'
    end

    expect(current_path).to eq search_path
    expect(page).to have_content 'MyString'
  end

  scenario 'User can search by answers', js: true do
    visit search_path

    ThinkingSphinx::Test.run do
      select 'ответы', from: 'Search by'
      fill_in 'Search query', with: 'MyText'
      click_on 'Найти'
    end

    expect(current_path).to eq search_path
    expect(page).to have_content 'MyText'
  end

  scenario 'User can search by comments', js: true do
    visit search_path

    ThinkingSphinx::Test.run do
      select 'комментарии', from: 'Search by'
      fill_in 'Search query', with: 'MyText'
      click_on 'Найти'
    end

    expect(current_path).to eq search_path
    expect(page).to have_content 'MyText'
  end

  scenario 'User can search by users', js: true do
    visit search_path

    ThinkingSphinx::Test.run do
      select 'пользователи', from: 'Search by'
      fill_in 'Search query', with: 'user'
      click_on 'Найти'
    end

    expect(current_path).to eq search_path
    expect(page).to have_content 'user'
  end
end