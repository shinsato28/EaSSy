class NovelComment < ApplicationRecord
  belongs_to :user
  belongs_to :novel

  # コメントは100文字以下、空は禁止
  validates :comment,length:{maximum:100},presence:true
end
