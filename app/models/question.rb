class Question < ApplicationRecord
  validates :title, :body, presence: true

  belongs_to :user

  def created_before
    @numbers_of_day = (Time.now - self.created_at).to_f/60/60/24
    if @numbers_of_day >= 1
      "опубликовано около #{ @numbers_of_day.to_i } дней назад"
    else
      "опубликовано менее #{ ((@numbers_of_day - @numbers_of_day.to_i) * 24).to_i + 1 } часов назад"
    end
  end
end
