require 'rails_helper'

feature 'View question' do
  given(:question) { create(:question) }
  given(:questions) { create_list(:question, 3) }

  scenario 'All guests can view questions' do
    questions

    visit questions_path

    questions.each do |q|
      expect(page).to have_link q.title
    end
  end
end