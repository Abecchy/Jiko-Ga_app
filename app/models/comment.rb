class Comment < ApplicationRecord
  after_create_commit :create_comment_notification

  belongs_to :user
  belongs_to :post
  has_one :notification, as: :notifiable, dependent: :destroy

  validates :body, presence: true, length: { maximum: 65_535 }

  private

  def create_comment_notification
    return if self.post.user_id == self.user_id

    Notification.create!(
      sender_id: self.user_id,
      recipient_id: self.post.user_id,
      notifiable: self,
      action_type: Notification.action_types[:commented_on_the_post]
    )
  end
end
