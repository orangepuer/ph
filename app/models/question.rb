class Question < ApplicationRecord
  belongs_to :user
  has_many :answers
  has_many :attachments, as: :attachmentable, dependent: :destroy
  has_many :comments, as: :commentable
  has_many :subscriptions

  validates :title, :body, presence: true

  accepts_nested_attributes_for :attachments, reject_if: :all_blank, allow_destroy: true

  after_commit :calculate_reputation, :on => :create

  scope :created_recently, -> { where('created_at >= ?', 1.day.ago) }

  def created_before
    @numbers_of_day = (Time.now - self.created_at).to_f/60/60/24
    if @numbers_of_day >= 1
      "опубликовано около #{ @numbers_of_day.to_i } дней назад"
    else
      "опубликовано менее #{ ((@numbers_of_day - @numbers_of_day.to_i) * 24).to_i + 1 } часов назад"
    end
  end

  private

  def calculate_reputation
    ReputationJob.perform_later(self)
  end
end
