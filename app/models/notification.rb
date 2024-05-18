class Notification < ApplicationRecord
  belongs_to :sender, class_name: 'User'
  belongs_to :recipient, class_name: 'User'
  belongs_to :notifiable, polymorphic: true

  scope :unread, -> { where(read: false) }

  enum action_type: {
    commented_on_the_post: 0,
    liked_the_post:        1,
    followed_you:          2
  }
end
