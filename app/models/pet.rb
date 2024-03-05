class Pet < ApplicationRecord
  mount_uploader :pet_avatar, PetAvatarUploader

  belongs_to :user

  enum gender: { male: 0, female: 1 }
end
