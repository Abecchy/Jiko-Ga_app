class Pet < ApplicationRecord
  mount_uploader :pet_avatar, PetAvatarUploader

  belongs_to :user
  has_many :post_pets, dependent: :destroy
  has_many :posts, through: :post_pets

  enum gender: { male: 0, female: 1 }
end
