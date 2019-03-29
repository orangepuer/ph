class ProfileSerializer < ActiveModel::Serializer
  attributes :id, :admin, :created_at, :updated_at, :email
end