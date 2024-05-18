class Like < ApplicationRecord
  after_create_commit :create_like_notification

  belongs_to :user
  belongs_to :post
  has_one :notification, as: :notifiable, dependent: :destroy

  validates :user_id, uniqueness: { scope: :post_id }

  private

  def create_like_notification
    return if self.post.user_id == self.user_id

    Notification.create!(
      sender_id: self.user_id,
      recipient_id: self.post.user_id,
      notifiable: self,
      action_type: Notification.action_types[:liked_the_post]
    )
  end
end
