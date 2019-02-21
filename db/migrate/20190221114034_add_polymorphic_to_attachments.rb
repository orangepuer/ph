class AddPolymorphicToAttachments < ActiveRecord::Migration[5.2]
  def change
    add_belongs_to :attachments, :attachmentable
    add_column :attachments, :attachmentable_type, :string
    add_index :attachments, :attachmentable_type
  end
end
