class User < ApplicationRecord
  # "is_deleted"カラムが変更された際に呼び出される
  before_update :update_novels_unpublished, if: :is_deleted_changed?

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :novels
  has_many :novel_comments, dependent: :destroy

  has_many :favorites, dependent: :destroy

  # フォローをした、されたの関係
  has_many :relationships, class_name: "Relationship", foreign_key: "follower_id", dependent: :destroy
  has_many :reverse_of_relationships, class_name: "Relationship", foreign_key: "followed_id", dependent: :destroy

  # 一覧画面で使う
  has_many :followings, through: :relationships, source: :followed
  has_many :followers, through: :reverse_of_relationships, source: :follower

  # ユーザーネームは20文字以下
  validates :name,length:{maximum:20},presence:true,uniqueness: true


  # フォローしたときの処理
  def follow(user_id)
    relationships.create(followed_id: user_id)
  end
  # フォローを外すときの処理
  def unfollow(user_id)
    relationships.find_by(followed_id: user_id).destroy
  end
  # フォローしているか判定
  def following?(user)
    followings.include?(user)
  end

  # ゲストログイン
  def self.guest
    find_or_create_by!(name: 'guestuser' ,email: 'guest@example.com') do |user|
      user.password = SecureRandom.urlsafe_base64
      user.name = "guestuser"
      user.introduction = "ゲストユーザーです"
    end
  end

  # ユーザー検索機能
  def self.search_for(content)
    User.where('name LIKE ?', '%' + content + '%').distinct
  end

  private

  # userのis_deletedがtrueの場合、投稿した小説をすべて非公開にする。
  def update_novels_unpublished
    if self.is_deleted
      self.novels.update_all(is_unpublished: true)
    end
  end

end
