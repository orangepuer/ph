class Answer < ApplicationRecord
  belongs_to :question
  belongs_to :user
  has_many :attachments, as: :attachmentable, dependent: :destroy

  validates :body, presence: true

  accepts_nested_attributes_for :attachments, reject_if: :all_blank, allow_destroy: true

  def get_attachments
    attachments_data = []

    self.attachments.each do |attachment|
      attachments_data << { name: attachment.file.filename, url: attachment.file.url }
    end

    attachments_data
  end
end
