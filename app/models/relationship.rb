class Relationship < ApplicationRecord
  after_create_commit :create_relationship_notification

  belongs_to :follower, class_name: 'User'
  belongs_to :followed, class_name: 'User'
  has_one :notification, as: :notifiable, dependent: :destroy

  validates :follower_id, presence: true
  validates :followed_id, presence: true

  private

  def create_relationship_notification
    Notification.create!(
      sender_id: self.follower_id,
      recipient_id: self.followed_id,
      notifiable: self,
      action_type: Notification.action_types[:followed_you]
    )
  end
end
