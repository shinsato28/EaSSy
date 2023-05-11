class Novel < ApplicationRecord
  has_many :favorites, dependent: :destroy
  has_many :novel_comments, dependent: :destroy
  has_many :tag_maps, dependent: :destroy
  has_many :tags, through: :tag_maps
  belongs_to :user

  validates :title,length:{maximum:50},presence:true
  validates :body,presence:true


  # メソッド
  def favorited_by?(user)
    favorites.exists?(user_id: user&.id)
  end

  scope :most_favorite, -> { left_joins(:favorites).select(:id, "COUNT(favorites.id) AS favorites_count").group(:id) }
  scope :latest, -> {order(created_at: :desc)}

  def save_posts(tags)
    # 付けられたタグを取得
    current_tags = self.tags.pluck(:name) unless self.tags.nil?

    old_tags = current_tags - tags
    new_tags = tags - current_tags

    old_tags.each do |old_name|
      self.tags.delete Tag.find_by(name:old_name)
    end

    new_tags.each do |new_name|
      post_tag = Tag.find_or_create_by(name:new_name)
      self.tags << post_tag
    end
  end

  # 小説検索機能
  # novelのタイトルとつけられたタグから部分一致で探す
  def self.search_by_keywords(contents)
    # eachで使う変数の初期化
    novel_results = self.where(is_deleted: false, is_unpublished: false).where('title LIKE ?', "%#{contents[0]}%")
    tags = Tag.where('name LIKE ?', "%#{contents[0]}%")
    tag_results = tags.flat_map { |tag| tag.novels.where(is_unpublished: false, is_deleted: false) }.sort_by(&:created_at).reverse

    # 検索欄に入力された複数のワードをeachで取り出し、結果に入れる
    contents[1..-1].each do |content|
      novel_results = novel_results.where('title LIKE ?', "%#{content}%")
      tags = Tag.where('name LIKE ?', "%#{content}%")
      tag_results = tags.flat_map { |tag| tag.novels.where(is_unpublished: false, is_deleted: false) }.sort_by(&:created_at).reverse
    end

    # novelのタイトルの検索結果とtagの検索結果のハッシュを結合して、作成日が新しい順、重複なしで返す
    result = (novel_results + tag_results).sort_by(&:created_at).reverse
    return result.uniq
  end

end
