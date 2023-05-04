class Novel < ApplicationRecord
  has_many :favorites, dependent: :destroy
  has_many :book_comments, dependent: :destroy
  has_many :tag_maps, dependent: :destroy
  has_many :tags, through: :tag_maps
  belongs_to :user

  validates :title,length:{maximum:50}


  def favorited_by?(user)
    favorites.exists?(user_id: user.id)
  end

  def save_posts(tags)
    # 付けられたタグを取得
    current_tags = self.tags.pluck(:name) unless self.tags.nil?

    old_tags = current_tags - tags
    new_tags = tags - current_tags

    old_tags.each do |old_name|
      self.tags.delete Tag.find_by(name: old_name)
    end

    new_tags.each do |new_name|
      post_tag = Tag.find_or_create_by(name: new_name)
      self.tags << post_tag
    end
  end

end
