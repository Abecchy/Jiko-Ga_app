class User < ApplicationRecord
  authenticates_with_sorcery!
  mount_uploader :avatar, AvatarUploader

  has_many :posts, dependent: :destroy
  has_many :comments, dependent: :destroy
  has_many :likes, dependent: :destroy
  has_many :like_posts, through: :likes, source: :post

  validates :name, presence: true, length: { maximum: 255 }
  validates :email, presence: true, uniqueness: true
  validates :password, length: { minimum: 3 }, if: -> { new_record? || changes[:crypted_password] }
  validates :password, confirmation: true, if: -> { new_record? || changes[:crypted_password] }
  validates :password_confirmation, presence: true, if: -> { new_record? || changes[:crypted_password] }

  # 持ち主判定
  def own?(object)
    object&.user_id == id
  end

  # いいね登録
  def like(post)
    like_posts << post
  end

  # いいね解除
  def unlike(post)
    like_posts.destroy(post)
  end

  # いいね判定
  def like?(post)
    like_posts.include?(post)
  end
end
