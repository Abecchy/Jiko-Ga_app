class Post < ApplicationRecord
  mount_uploader :post_image, PostImageUploader

  belongs_to :user
  has_many :comments, dependent: :destroy

  validates :post_image, presence: true
  validates :title, presence: true, length: { maximum: 255 }
  validates :body, presence: true, length: { maximum: 65_535 }
end
