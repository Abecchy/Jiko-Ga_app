class Post < ApplicationRecord
  mount_uploader :post_image, PostImageUploader

  belongs_to :user
  has_many :comments, dependent: :destroy
  has_many :likes, dependent: :destroy
  has_many :post_tags, dependent: :destroy
  has_many :tags, through: :post_tags

  validates :post_image, presence: true
  validates :title, presence: true, length: { maximum: 255 }
  validates :body, presence: true, length: { maximum: 65_535 }

  scope :created_today, -> { where('created_at >= ?', Time.zone.now.beginning_of_day) }

  def self.ransackable_attributes(auth_object = nil)
    %w[title body]
  end

  def self.ransackable_associations(auth_object = nil)
    []
  end

  # 事故画投稿時のタグ付け
  def save_tags(tag_list)
    tag_list.each do |sent_tag|
      tag = Tag.find_or_create_by(name: sent_tag)
      self.tags << tag
    end
  end

  # 事故画編集時のタグ付け
  def update_tags(latest_tags)
    if self.tags.empty?
      latest_tags.each do |latest_tag|
        self.tags.find_or_create_by(name: latest_tag)
      end
    elsif latest_tags.empty?
      self.tags.each do |tag|
        self.tags.delete(tag)
      end
    else
      current_tags = self.tags.map(&:name)
      old_tags = current_tags - latest_tags
      new_tags = latest_tags - current_tags

      old_tags.each do |old_tag|
        tag = self.tags.find_by(name: old_tag)
        self.tags.delete(tag) if tag.present?
      end

      new_tags.each do |new_tag|
        tag = Tag.find_or_create_by(name: new_tag)
        self.tags << tag unless self.tags.include?(tag)
      end
    end
  end
end
