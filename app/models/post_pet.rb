class PostPet < ApplicationRecord
  belongs_to :post
  belongs_to :pet

  validates :post_id, presence: true
  validates :pet_id, presence: true
  validates :pet_id, uniqueness: { scope: :post_id }
end
