class Tag < ApplicationRecord
  has_many :tag_maps, dependent: :destroy
  has_many :novels, through: :tag_maps

  def self.search_novels_for(content)
    tags = Tag.where(name: content)
    return tags.inject(init = []) {|result, tag| result + tag.novels.where(is_unpublished: false, is_deleted: false).order(created_at: :desc)}
  end
end
