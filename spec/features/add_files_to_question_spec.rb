require 'rails_helper'

feature 'Add files to question' do
  given(:user) { create(:user) }

  scenario 'User add file when ask question' do
    sign_in user

    visit new_question_path
    fill_in 'Title', with: 'test question'
    fill_in 'Body', with: 'test text'
    attach_file 'File', "#{Rails.root}/spec/rails_helper.rb"
    click_on 'Create'

    expect(page).to have_link 'rails_helper.rb', href: '/uploads/attachment/file/1/rails_helper.rb'
  end
end